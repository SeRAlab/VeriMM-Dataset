module top_module(
    input [7:0] A,
    input [7:0] B,
    input SEL,
    output reg [7:0] C
);always @(*) begin
        if(SEL == 0) begin
            if((A + B) > 255) begin
                C = 255;
            end else begin
                C = A + B;
            end
        end else begin
            if(A >= B) begin
                C = A - B;
            end else begin
                C = 0;
            end
        end
    end

endmodule