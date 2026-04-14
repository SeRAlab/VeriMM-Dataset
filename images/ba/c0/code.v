module top_module(
    input [3:0] A,
    input [1:0] B,
    output reg [2:0] Z
    );always @(*) begin
        if (A > 7) begin
            Z = 3'b111;
        end else if (B > 3) begin
            Z = 3'b000;
        end else begin
            Z = {A[3:2], B, A[1:0]};
        end
    end
    
endmodule