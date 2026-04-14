module top_module(
    input [3:0] A,
    input [3:0] B,
    input en,
    input sub,
    input rst,
    output reg [3:0] sum,
    output reg overflow
);always @(posedge en, posedge rst) begin
        if (rst) begin
            sum <= 4'b0000;
            overflow <= 1'b0;
        end else begin
            if (sub) begin
                sum <= A - B;
                if (A < B) begin
                    overflow <= 1'b1;
                end else begin
                    overflow <= 1'b0;
                end
            end else begin
                sum <= A + B;
                if (sum < A) begin
                    overflow <= 1'b1;
                end else begin
                    overflow <= 1'b0;
                end
            end
        end
    end

endmodule