module top_module(
    input [3:0] A,
    input [3:0] B,
    input sel,
    output reg [3:0] C  // Change wire to reg for procedural assignment
);always @(*) begin
        if(sel == 1'b0) begin
            C = A + B;
        end else begin
            C = A & B;
        end
    end

endmodule