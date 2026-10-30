`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2026 08:59:35 AM
// Design Name: 
// Module Name: Top_ControlPath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Top_ControlPath (
    input  wire        clk,          // On-board clock (e.g., 100MHz)
    input  wire        reset,        // Active high reset button
    input  wire        btn_step,     // Pushbutton to advance FSM / latch inputs
    input  wire [15:0] sw,           // Physical switches
    output reg  [15:0] led           // Physical LEDs
);

    // -------------------------------------------------------------
    // Switch Mapping
    // -------------------------------------------------------------
    // sw[6:0]   : Opcode (7 bits)
    // sw[9:7]   : funct3 (3 bits)
    // sw[10]    : funct7[5] (1 bit, enough for SUB vs ADD distinction)
    // -------------------------------------------------------------
    
    wire [6:0] sw_opcode  = sw[6:0];
    wire [2:0] sw_funct3  = sw[9:7];
    wire       sw_funct7_5 = sw[10];

    // Debounced button signal
    wire btn_tick;

    // Instantiate Button Debouncer (Reused from Lab 5)
    ButtonDebouncer debouncer_inst (
        .clk(clk),
        .reset(reset),
        .btn_in(btn_step),
        .btn_out(btn_tick)
    );

    // Internal Registers for FSM / Input Latching
    reg [6:0] reg_opcode;
    reg [2:0] reg_funct3;
    reg       reg_funct7_5;

    // Control Unit Output Wires
    wire       RegWrite;
    wire [1:0] ALUOp;
    wire       MemRead;
    wire       MemWrite;
    wire       ALUSrc;
    wire       MemtoReg;
    wire       Branch;
    wire [3:0] ALUControl;

    // -------------------------------------------------------------
    // Sub-module Instantiations
    // -------------------------------------------------------------
    MainControl main_ctrl (
        .opcode(reg_opcode),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .Branch(Branch)
    );

    ALUControl alu_ctrl (
        .ALUOp(ALUOp),
        .funct3(reg_funct3),
        .funct7_5(reg_funct7_5),
        .ALUControl(ALUControl)
    );

    // -------------------------------------------------------------
    // FSM State Encoding
    // -------------------------------------------------------------
    localparam STATE_IDLE = 1'b0;
    localparam STATE_LOAD = 1'b1;

    reg state, next_state;

    // FSM State Register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= STATE_IDLE;
            reg_opcode   <= 7'b0;
            reg_funct3   <= 3'b0;
            reg_funct7_5 <= 1'b0;
        end else begin
            state <= next_state;
            if (state == STATE_LOAD) begin
                // Latch physical switch values into control inputs
                reg_opcode   <= sw_opcode;
                reg_funct3   <= sw_funct3;
                reg_funct7_5 <= sw_funct7_5;
            end
        end
    end

    // FSM Next-State Logic
    always @(*) begin
        case (state)
            STATE_IDLE: next_state = btn_tick ? STATE_LOAD : STATE_IDLE;
            STATE_LOAD: next_state = STATE_IDLE;
            default:    next_state = STATE_IDLE;
        endcase
    end

    // -------------------------------------------------------------
    // LED Output Mapping
    // -------------------------------------------------------------
    // led[0]   : RegWrite
    // led[1]   : ALUSrc
    // led[2]   : MemRead
    // led[3]   : MemWrite
    // led[4]   : MemtoReg
    // led[5]   : Branch
    // led[7:6] : ALUOp (2 bits)
    // led[11:8]: ALUControl (4 bits)
    // led[15:12]: Reserved / Unused (Off)
    // -------------------------------------------------------------
    always @(*) begin
        led[0]     = RegWrite;
        led[1]     = ALUSrc;
        led[2]     = MemRead;
        led[3]     = MemWrite;
        led[4]     = MemtoReg;
        led[5]     = Branch;
        led[7:6]   = ALUOp;
        led[11:8]  = ALUControl;
        led[15:12] = 4'b0000;
    end

endmodule
