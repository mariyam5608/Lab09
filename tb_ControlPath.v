`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2026 08:44:50 AM
// Design Name: 
// Module Name: tb_ControlPath
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

module tb_ControlPath();

    reg [6:0] opcode;
    reg [1:0] ALUOp_in;
    reg [2:0] funct3;
    reg       funct7_5;

    wire RegWrite, MemRead, MemWrite, ALUSrc, MemtoReg, Branch;
    wire [1:0] ALUOp_out;
    wire [3:0] ALUControl;

    // Instantiate Main Control
    MainControl uut_main (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUOp(ALUOp_out),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .ALUSrc(ALUSrc),
        .MemtoReg(MemtoReg),
        .Branch(Branch)
    );

    // Instantiate ALU Control
    ALUControl uut_alu (
        .ALUOp(ALUOp_out),
        .funct3(funct3),
        .funct7_5(funct7_5),
        .ALUControl(ALUControl)
    );

    initial begin
        // Monitor outputs
        $monitor("Time=%0t | Opcode=%b | RegWrite=%b | ALUSrc=%b | MemRead=%b | MemWrite=%b | Branch=%b | ALUControl=%b",
                 $time, opcode, RegWrite, ALUSrc, MemRead, MemWrite, Branch, ALUControl);

        // Test R-type ADD (`0110011`, funct3=000, funct7[5]=0)
        opcode = 7'b0110011; funct3 = 3'b000; funct7_5 = 1'b0; #10;

        // Test R-type SUB (`0110011`, funct3=000, funct7[5]=1)
        opcode = 7'b0110011; funct3 = 3'b000; funct7_5 = 1'b1; #10;

        // Test ADDI (`0010011`)
        opcode = 7'b0010011; funct3 = 3'b000; funct7_5 = 1'b0; #10;

        // Test LW (`0000011`)
        opcode = 7'b0000011; funct3 = 3'b010; funct7_5 = 1'b0; #10;

        // Test SW (`0100011`)
        opcode = 7'b0100011; funct3 = 3'b010; funct7_5 = 1'b0; #10;

        // Test BEQ (`1100011`)
        opcode = 7'b1100011; funct3 = 3'b000; funct7_5 = 1'b0; #10;

        $finish;
    end

endmodule