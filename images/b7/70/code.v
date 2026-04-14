module top_module(
    input clk,
    input [3:0] data_in,
    input [1:0] shift_amount,
    input [2:0] parallel_load,
    input shift,
    input control,
    output [2:0] out
);// 4-bit Barrel Shifter
    reg [3:0] shifted_data;
    always @(*) begin
        case(shift_amount)
            2'b00: shifted_data = data_in;
            2'b01: shifted_data = {data_in[0], data_in[3:1]}; // Fixed order
            2'b10: shifted_data = {data_in[1:0], data_in[3:2]}; // Fixed order
            2'b11: shifted_data = {data_in[2:0]}; // Fixed order
            default: shifted_data = 4'b0000;
        endcase
    end

    // 3-bit Shift Register
    reg [2:0] reg_data;
    always @(posedge clk) begin
        if(shift) begin
            if(control) reg_data <= {reg_data[1:0], 1'b0};
            else reg_data <= {1'b0, reg_data[2:1]};
        end
        else if(parallel_load != 3'b111) begin
            reg_data <= parallel_load;
        end
    end

    // AND Gate
    assign out = shifted_data[2:0] & reg_data; // Only AND the relevant bits

endmodule