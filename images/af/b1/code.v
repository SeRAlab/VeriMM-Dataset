module top_module(
    input clk,
    input reset,      // Synchronous active-high reset
    input [3:0] ABCD, // Input for priority encoder
    output reg [1:0] Y, // Output from priority encoder
    output reg [7:0] sum // Output from functional module
);reg [3:0] count; // 4-bit counter

// Synchronous reset
always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0;
    end else begin
        count <= count + 1;
    end
end

// Priority encoder
always @(ABCD) begin
    casez(ABCD)
        4'b0001: Y <= 2'b00;
        4'b0010: Y <= 2'b01;
        4'b0100: Y <= 2'b10;
        4'b1000: Y <= 2'b11;
        default: Y <= 2'b00;
    endcase
end

// Functional module
always @(count, Y) begin
    sum <= count + Y;
end

endmodule