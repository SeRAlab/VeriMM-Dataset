module top_module(
    input  [7:0] A,
    input  [7:0] B,
    input        OP,
    input        CLK,
    input        RST,
    output [7:0] C
);reg [7:0] C_reg;

    always @(posedge CLK) begin
        if (RST) begin
            C_reg <= 8'b0;
        end else if (OP == 1) begin
            C_reg <= A - B;
        end else begin
            C_reg <= A + B;
        end
    end

    assign C = C_reg;

endmodule