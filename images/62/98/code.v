module top_module(A,B,RESULT, CLK);output reg [15:0] RESULT;

    input [15:0] A,B;
    input CLK;

    always @ (posedge CLK) begin
        RESULT <= A * B;
    end

endmodule