module top_module(
    input [15:0] data_in,
    input [3:0] shift_amount,
    output [15:0] shifted_output,
    output overflow
);reg [15:0] shifted_data;
    reg overflow_flag;

    always @(*) begin
        case(shift_amount)
            4'b0000: shifted_data = data_in;
            4'b0001: shifted_data = {data_in[14:0], data_in[15]};
            4'b0010: shifted_data = {data_in[13:0], data_in[15:14]};
            4'b0011: shifted_data = {data_in[12:0], data_in[15:13]};
            4'b0100: shifted_data = {data_in[11:0], data_in[15:12]};
            4'b0101: shifted_data = {data_in[10:0], data_in[15:11]};
            4'b0110: shifted_data = {data_in[9:0], data_in[15:10]};
            4'b0111: shifted_data = {data_in[8:0], data_in[15:9]};
            4'b1000: shifted_data = {data_in[7:0], data_in[15:8]};
            4'b1001: shifted_data = {data_in[6:0], data_in[15:7]};
            4'b1010: shifted_data = {data_in[5:0], data_in[15:6]};
            4'b1011: shifted_data = {data_in[4:0], data_in[15:5]};
            4'b1100: shifted_data = {data_in[3:0], data_in[15:4]};
            4'b1101: shifted_data = {data_in[2:0], data_in[15:3]};
            4'b1110: shifted_data = {data_in[1:0], data_in[15:2]};
            4'b1111: shifted_data = {data_in[0], data_in[15:1]};
        endcase

        if(shift_amount > 12) begin
            overflow_flag = 1;
        end else begin
            overflow_flag = 0;
        end
    end

    assign shifted_output = shifted_data;
    assign overflow = overflow_flag;

endmodule