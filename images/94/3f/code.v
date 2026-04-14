module top_module(
    input cx0,
    input cx1,
    output reg [1:0] bm
);always @(*) begin
        bm[0] = cx0; // Example logic for bm[0]
        bm[1] = cx1; // Example logic for bm[1]
    end
endmodule