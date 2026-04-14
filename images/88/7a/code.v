module top_module(input wire clk, output wire dout);reg [7:0] out = 8'hAA;
    wire feedback = !(out[7] ^ out[3]);

    always @(posedge clk) begin
        out <= {out[6],out[5],
              out[4],out[3],
              out[2],out[1],
              out[0], feedback};
    end
    assign dout = out[0];
endmodule