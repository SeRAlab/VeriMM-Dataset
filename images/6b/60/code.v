module top_module(
    input [15:0] I,
    input EN,
    output reg [3:0] O
);reg [3:0] temp;

always @ (posedge EN) begin
    temp <= I[15:12] > I[11:8] > I[7:4] > I[3:0];
end

assign O = temp[3:0];

endmodule