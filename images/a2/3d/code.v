module top_module(
    input [7:0] data_in,
    input [2:0] shift_amount,
    input [3:0] SEL,
    input EN,
    output reg [3:0] Y
);reg [7:0] shifted_data;

always @(*) begin
    case (shift_amount)
        3'b000: shifted_data = data_in;
        3'b001: shifted_data = {data_in[6:0], data_in[7]};
        3'b010: shifted_data = {data_in[5:0], data_in[7:6]};
        3'b011: shifted_data = {data_in[4:0], data_in[7:5]};
        3'b100: shifted_data = {data_in[3:0], data_in[7:4]};
        3'b101: shifted_data = {data_in[2:0], data_in[7:3]};
        3'b110: shifted_data = {data_in[1:0], data_in[7:2]};
        3'b111: shifted_data = {data_in[0], data_in[7:1]};
    endcase
end

always @(SEL, EN, shifted_data) begin
    if (EN == 1'b0) begin
        Y <= 4'b0000;
    end else begin
        case (SEL)
            4'b0001: Y <= shifted_data[0];
            4'b0010: Y <= shifted_data[1];
            4'b0100: Y <= shifted_data[2];
            4'b1000: Y <= shifted_data[3];
            default: Y <= 4'b0000;
        endcase
    end
end

endmodule