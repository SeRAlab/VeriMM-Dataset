module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [2:0] O
);always @(*) begin
        if(A < B) begin
            O = 3'b000;
        end else if(A == B) begin
            O = 3'b001;
        end else begin
            O = 3'b010;
        end
    end

endmodule