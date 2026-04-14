module shift_register_16bit (
    input clk,
    input rst,
    input en,
    input si,
    output reg so
);

reg [15:0] shift_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        shift_reg <= 16'b0;
    end else if (en) begin
        shift_reg <= {shift_reg[14:0], si};
    end
end

always @(*) begin
    so = shift_reg[15];
end

endmodule