`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2026 09:01:09 AM
// Design Name: 
// Module Name: ButtonDebouncer
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


module ButtonDebouncer (
    input  wire clk,
    input  wire reset,
    input  wire btn_in,
    output reg  btn_out
);

    reg [19:0] counter;
    reg        btn_sync_0, btn_sync_1;
    reg        btn_debounced;
    reg        btn_debounced_delay;

    // Synchronize button input to clock domain
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            btn_sync_0 <= 1'b0;
            btn_sync_1 <= 1'b0;
        end else begin
            btn_sync_0 <= btn_in;
            btn_sync_1 <= btn_sync_0;
        end
    end

    // Counter-based Debounce Logic (~10ms delay at 100MHz clock)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 20'd0;
            btn_debounced <= 1'b0;
        end else begin
            if (btn_sync_1 != btn_debounced) begin
                counter <= counter + 1'b1;
                if (counter == 20'hFFFFF) begin
                    btn_debounced <= btn_sync_1;
                    counter <= 20'd0;
                end
            end else begin
                counter <= 20'd0;
            end
        end
    end

    // Edge Detection for single-clock pulse output
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            btn_debounced_delay <= 1'b0;
            btn_out <= 1'b0;
        end else begin
            btn_debounced_delay <= btn_debounced;
            btn_out <= (btn_debounced && !btn_debounced_delay);
        end
    end

endmodule
