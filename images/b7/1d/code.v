module top_module(in0, in1, out);input in0;
input in1;
output reg [1:0] out;

always @ (in0, in1) begin
    if (in0 && !in1) // in0 is high and in1 is low
        out <= 2'b01;
    else if (!in0 && in1) // in0 is low and in1 is high
        out <= 2'b10;
    else if (in0 && in1) // both inputs are high
        out <= 2'b10;
    else // both inputs are low
        out <= 2'b00;
end

endmodule