module top_module(
    input A1,
    input A2,
    input B1,
    output Y,
    input clk
);reg Y_reg;

    always @(posedge clk) begin
        if (A1 && A2) begin
            Y_reg <= 1;
        end else if (!A1 && !A2) begin
            Y_reg <= 0;
        end else if (A1 && !A2) begin
            Y_reg <= ~B1;
        end else begin
            Y_reg <= B1;
        end
    end

    assign Y = Y_reg;

endmodule