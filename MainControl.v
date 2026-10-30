`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2026 08:41:27 AM
// Design Name: 
// Module Name: MainControl
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


module MainControl (
    input  [6:0] opcode,
    output reg   RegWrite,
    output reg [1:0] ALUOp,
    output reg   MemRead,
    output reg   MemWrite,
    output reg   ALUSrc,
    output reg   MemtoReg,
    output reg   Branch
);

always @(*) begin
    RegWrite = 1'b0;
    ALUOp    = 2'b00;
    MemRead  = 1'b0;
    MemWrite = 1'b0;
    ALUSrc   = 1'b0;
    MemtoReg = 1'b0;
    Branch   = 1'b0;

    case (opcode)
        7'b0110011: begin // R-type
            RegWrite = 1'b1;
            ALUOp    = 2'b10;
        end
        7'b0010011: begin // ADDI
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
            ALUOp    = 2'b10;
        end
        7'b0000011: begin // Loads (LW, LH, LB)
            RegWrite = 1'b1;
            ALUSrc   = 1'b1;
            MemRead  = 1'b1;
            MemtoReg = 1'b1;
            ALUOp    = 2'b00;
        end
        7'b0100011: begin // Stores (SW, SH, SB)
            ALUSrc   = 1'b1;
            MemWrite = 1'b1;
            ALUOp    = 2'b00;
        end
        7'b1100011: begin // BEQ
            Branch   = 1'b1;
            ALUOp    = 2'b01;
        end
        default: begin
            RegWrite = 1'b0;
        end
    endcase
end

endmodule
