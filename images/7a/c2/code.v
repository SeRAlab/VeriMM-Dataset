module shift_reg_16bit(
    input clk,
    input rst,
    input load,
    input sin,
    input [15:0] pdata,
    output sout,
    output [15:0] q
);

    reg [15:0] shift_reg;

    always @(posedge clk) begin
        if (rst) begin
            shift_reg <= 16'b0;
        end else if (load) begin
            shift_reg <= pdata;
        end else begin
            shift_reg <= {shift_reg[14:0], sin};
        end
    end

    assign sout = shift_reg[15];
    assign q = shift_reg;

endmodule