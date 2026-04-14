module top_module(
    input clk,
    input reset,
    input [7:0] d,
    input select,
    output reg out_and,
    output reg [7:0] q
);// Majority gate
wire majority;
assign majority = (d[0] & d[1]) | (d[0] & d[2]) | (d[1] & d[2]);

// D flip-flop chain
reg [7:0] dff_out;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        dff_out <= 8'b0;
    end else begin
        dff_out <= {dff_out[6:0], (select ? majority : d[7])};
    end
end

// Output of the last flip-flop
assign q = dff_out;

// Bitwise AND operation
always @(*) begin
    out_and = majority & dff_out[7];
end

// Synchronous reset input of the flip-flop chain
assign reset = out_and;

endmodule