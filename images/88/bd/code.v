module top_module(
input A, B, C, D, E, F, G, H,
output reg out

    );always@(*) begin
out=(A&B&C&D&E&F&G&H);
end
endmodule