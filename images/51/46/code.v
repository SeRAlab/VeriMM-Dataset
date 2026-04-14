module top_module(
    input clk,
    input [3:0] addrIn,
    output reg [7:0] dataOut = 0
    );always @ (posedge clk)
        case (addrIn)
            4'h0 : dataOut = 8'h2B;
            4'h1 : dataOut = 8'h2B;
            4'h2 : dataOut = 8'h3E;
            4'h3 : dataOut = 8'h2D;
            4'h4 : dataOut = 8'h2D;
            default : dataOut = 8'h00;
        endcase

endmodule