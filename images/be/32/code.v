module top_module(
    input clk,
    input A1,
    input A2,
    input B1,
    output reg Y
);always @(posedge clk) begin
        if (A1 && A2) begin
            Y <= 0;
        end else if (!A1 && A2) begin
            Y <= 1;
        end else if (A1 && !A2) begin
            Y <= B1;
        end else begin
            Y <= 1;
        end
    end

endmodule