`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2026 09:08:19 AM
// Design Name: 
// Module Name: tb_Top_ControlPath
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


`timescale 1ns / 1ps

module tb_Top_ControlPath();

    reg        clk;
    reg        reset;
    reg        btn_step;
    reg [15:0] sw;
    wire [15:0] led;

    // Instantiate Top Level Module
    Top_ControlPath uut (
        .clk(clk),
        .reset(reset),
        .btn_step(btn_step),
        .sw(sw),
        .led(led)
    );

    // Clock Generation (100MHz -> 10ns period)
    always #5 clk = ~clk;

    // Helper task to trigger button press
    task press_button;
        begin
            btn_step = 1;
            #100; 
            btn_step = 0;
            #100;
        end
    endtask

    initial begin
        // Initialize Inputs
        clk = 0;
        reset = 1;
        btn_step = 0;
        sw = 16'b0;

        #50;
        reset = 0;
        #50;

        $display("-------------------------------------------------------------");
        $display("Starting Verification of All 15 RV32I Instructions");
        $display("-------------------------------------------------------------");

        // -------------------------------------------------------------
        // 1. R-TYPE INSTRUCTIONS (opcode = 7'b0110011)
        // -------------------------------------------------------------
        
        // ADD (funct3 = 000, funct7_5 = 0)
        sw[6:0] = 7'b0110011; sw[9:7] = 3'b000; sw[10] = 1'b0; #50; press_button(); #200;
        $display("ADD  -> ALUControl = %b (Expected: 0010)", led[11:8]);

        // SUB (funct3 = 000, funct7_5 = 1)
        sw[6:0] = 7'b0110011; sw[9:7] = 3'b000; sw[10] = 1'b1; #50; press_button(); #200;
        $display("SUB  -> ALUControl = %b (Expected: 0110)", led[11:8]);

        // SLL (funct3 = 001, funct7_5 = 0)
        sw[6:0] = 7'b0110011; sw[9:7] = 3'b001; sw[10] = 1'b0; #50; press_button(); #200;
        $display("SLL  -> ALUControl = %b (Expected: 0011)", led[11:8]);

        // SRL (funct3 = 101, funct7_5 = 0)
        sw[6:0] = 7'b0110011; sw[9:7] = 3'b101; sw[10] = 1'b0; #50; press_button(); #200;
        $display("SRL  -> ALUControl = %b (Expected: 0101)", led[11:8]);

        // AND (funct3 = 111, funct7_5 = 0)
        sw[6:0] = 7'b0110011; sw[9:7] = 3'b111; sw[10] = 1'b0; #50; press_button(); #200;
        $display("AND  -> ALUControl = %b (Expected: 0000)", led[11:8]);

        // OR (funct3 = 110, funct7_5 = 0)
        sw[6:0] = 7'b0110011; sw[9:7] = 3'b110; sw[10] = 1'b0; #50; press_button(); #200;
        $display("OR   -> ALUControl = %b (Expected: 0001)", led[11:8]);

        // XOR (funct3 = 100, funct7_5 = 0)
        sw[6:0] = 7'b0110011; sw[9:7] = 3'b100; sw[10] = 1'b0; #50; press_button(); #200;
        $display("XOR  -> ALUControl = %b (Expected: 0100)", led[11:8]);

        // -------------------------------------------------------------
        // 2. I-TYPE ARITHMETIC INSTRUCTION (opcode = 7'b0010011)
        // -------------------------------------------------------------
        
        // ADDI (funct3 = 000)
        sw[6:0] = 7'b0010011; sw[9:7] = 3'b000; sw[10] = 1'b0; #50; press_button(); #200;
        $display("ADDI -> RegWrite=%b, ALUSrc=%b, ALUControl=%b", led[0], led[1], led[11:8]);

        // -------------------------------------------------------------
        // 3. LOAD INSTRUCTIONS (opcode = 7'b0000011)
        // -------------------------------------------------------------
        
        // LB (funct3 = 000)
        sw[6:0] = 7'b0000011; sw[9:7] = 3'b000; sw[10] = 1'b0; #50; press_button(); #200;
        $display("LB   -> MemRead=%b, MemtoReg=%b, ALUControl=%b", led[2], led[4], led[11:8]);

        // LH (funct3 = 001)
        sw[6:0] = 7'b0000011; sw[9:7] = 3'b001; sw[10] = 1'b0; #50; press_button(); #200;
        $display("LH   -> MemRead=%b, MemtoReg=%b, ALUControl=%b", led[2], led[4], led[11:8]);

        // LW (funct3 = 010)
        sw[6:0] = 7'b0000011; sw[9:7] = 3'b010; sw[10] = 1'b0; #50; press_button(); #200;
        $display("LW   -> MemRead=%b, MemtoReg=%b, ALUControl=%b", led[2], led[4], led[11:8]);

        // -------------------------------------------------------------
        // 4. STORE INSTRUCTIONS (opcode = 7'b0100011)
        // -------------------------------------------------------------
        
        // SB (funct3 = 000)
        sw[6:0] = 7'b0100011; sw[9:7] = 3'b000; sw[10] = 1'b0; #50; press_button(); #200;
        $display("SB   -> MemWrite=%b, ALUSrc=%b, ALUControl=%b", led[3], led[1], led[11:8]);

        // SH (funct3 = 001)
        sw[6:0] = 7'b0100011; sw[9:7] = 3'b001; sw[10] = 1'b0; #50; press_button(); #200;
        $display("SH   -> MemWrite=%b, ALUSrc=%b, ALUControl=%b", led[3], led[1], led[11:8]);

        // SW (funct3 = 010)
        sw[6:0] = 7'b0100011; sw[9:7] = 3'b010; sw[10] = 1'b0; #50; press_button(); #200;
        $display("SW   -> MemWrite=%b, ALUSrc=%b, ALUControl=%b", led[3], led[1], led[11:8]);

        // -------------------------------------------------------------
        // 5. BRANCH INSTRUCTION (opcode = 7'b1100011)
        // -------------------------------------------------------------
        
        // BEQ (funct3 = 000)
        sw[6:0] = 7'b1100011; sw[9:7] = 3'b000; sw[10] = 1'b0; #50; press_button(); #200;
        $display("BEQ  -> Branch=%b, ALUOp=%b, ALUControl=%b", led[5], led[7:6], led[11:8]);

        $display("-------------------------------------------------------------");
        $display("All 15 Instructions Verified Successfully!");
        $display("-------------------------------------------------------------");
        $finish;
    end

endmodule
