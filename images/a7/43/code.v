module top_module(
    input  A,
    input  B,
    input  C,
    input  D,
    output X,
    input  clk,
    input  rst
);reg X_reg;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            X_reg <= 1'b0;
        end else begin
            X_reg <= A & B & C & D;
        end
    end

    assign X = X_reg;

endmodule