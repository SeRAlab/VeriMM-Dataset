module top_module(
    input [3:0] A,
    input [3:0] B,
    input CTRL,
    output reg [3:0] C
);// Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    always @(*) begin
        if(CTRL == 0) begin
            C = A + B;
        end else begin
            C = {1'b0, A[3:1]} + {1'b0, B[3:1]};
        end
    end

endmodule