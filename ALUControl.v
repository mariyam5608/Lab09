`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2026 08:43:17 AM
// Design Name: 
// Module Name: ALUControl
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


module ALUControl (
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input        funct7_5, // Usually funct7[5]
    output reg [3:0] ALUControl
);

always @(*) begin
    // Default safe value
    ALUControl = 4'b0000;

    case (ALUOp)
        2'b00: ALUControl = 4'b0010; // Addition for Load/Store
        2'b01: ALUControl = 4'b0110; // Subtraction for Branch (BEQ)
        2'b10: begin // R-type / Arithmetic
            case (funct3)
                3'b000: ALUControl = (funct7_5) ? 4'b0110 : 4'b0010; // SUB : ADD/ADDI
                3'b001: ALUControl = 4'b0011; // SLL
                3'b101: ALUControl = 4'b0101; // SRL
                3'b111: ALUControl = 4'b0000; // AND
                3'b110: ALUControl = 4'b0001; // OR
                3'b100: ALUControl = 4'b0100; // XOR
                default: ALUControl = 4'b0000;
            endcase
        end
        default: ALUControl = 4'b0000;
    endcase
end

endmodule
