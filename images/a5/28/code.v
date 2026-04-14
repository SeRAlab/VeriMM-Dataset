module shift_reg_8bit(
    input wire clk,
    input wire rst,
    input wire load,
    input wire [1:0] shift_ctrl,
    input wire [7:0] data_in,
    output reg [7:0] data_out
    );

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_out <= 8'b00000000;
    end
    else if (load) begin
        data_out <= data_in;
    end
    else begin
        case (shift_ctrl)
            2'b01: data_out <= data_out << 1;
            2'b10: data_out <= data_out >> 1;
            default: data_out <= data_out;
        endcase
    end
end

endmodule