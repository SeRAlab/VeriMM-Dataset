module shift_reg_32bit (
    input wire clk,
    input wire rst,
    input wire shift_in,
    output reg [31:0] shift_out
);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            shift_out <= 32'b0;
        end else begin
            shift_out <= {shift_out[30:0], shift_in};
        end
    end

endmodule