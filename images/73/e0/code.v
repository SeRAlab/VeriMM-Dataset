module top_module(
    input clk,
    input reset, // Synchronous active-high reset
    input [7:0] in, // 8-bit input for the parity bit module
    input a, // Slowly changing 1-bit signal for the edge detection module
    output reg out // Final output
);reg [8:0] parity_bit; // 9-bit output from the parity bit module
reg [1:0] edge_detect; // 2-bit output from the edge detection module
reg [7:0] shift_reg; // 8-bit shift register for the parity bit module

// Parity bit module
always @ (posedge clk) begin
    if (reset) begin
        parity_bit <= 9'b0;
        shift_reg <= 8'b0;
    end else begin
        shift_reg <= {in, shift_reg[7:1]};
        parity_bit[8] <= ~^shift_reg;
        parity_bit[7:0] <= in;
    end
end

// Edge detection module
always @ (posedge clk) begin
    if (reset) begin
        edge_detect <= 2'b0;
    end else begin
        edge_detect[1] <= edge_detect[0];
        edge_detect[0] <= a;
    end
end

// Final output module
always @ (posedge clk) begin
    if (reset) begin
        out <= 1'b0;
    end else begin
        if (edge_detect[1] == 1'b0 && edge_detect[0] == 1'b1 && parity_bit[8] == 1'b1) begin
            out <= 1'b1;
        end else begin
            out <= 1'b0;
        end
    end
end

endmodule