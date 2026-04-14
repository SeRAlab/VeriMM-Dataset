module top_module(
    input [3:0] in,
    output reg [3:0] out,  // Change to reg because we are driving it in an always block
    output reg overflow     // Change to reg because we are driving it in an always block
);always @(*) begin
    if (in == 4'b1111) begin
        out = 4'b0000;        // Assign temp_out to out directly
        overflow = 1;
    end
    else begin
        out = in + 1;         // Assign the incremented value directly to out
        overflow = 0;
    end
end

endmodule