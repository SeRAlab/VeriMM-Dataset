module top_module(
    input clk,
    input reset,
    input [7:0] in,
    output reg [9:0] out,
    output reg red,
    output reg yellow,
    output reg green
);reg [8:0] parity_check;
reg [2:0] priority_enc;

always @(posedge clk) begin
    if (reset) begin
        parity_check <= 0;
        priority_enc <= 0;
        out <= 0;
        red <= 0;
        yellow <= 0;
        green <= 0;
    end else begin
        parity_check <= {in, 1'b0} ^ parity_check;
        priority_enc <= {1'b0, in} > priority_enc;
        out <= {priority_enc, parity_check};
        red <= ~parity_check[8];
        yellow <= priority_enc != 0;
        green <= parity_check[8];
    end
end

endmodule