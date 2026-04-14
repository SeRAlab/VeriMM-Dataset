module rle_encoder(
    input clk,
    input reset,
    input [1:0] data_in,  // 2'b00 for 0, 2'b01 for 1, extended for more bits
    input valid,
    output reg [7:0] count_out,
    output reg bit_out,
    output reg valid_out
);
    reg [7:0] count;
    reg current_bit;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 8'd0;
            current_bit <= 1'b0;
            valid_out <= 1'b0;
        end else if (valid) begin
            if (data_in[1] == current_bit) begin
                count <= count + 1;
            end else begin
                count_out <= count;
                bit_out <= current_bit;
                valid_out <= 1'b1;
                count <= 1;
                current_bit <= data_in[1];
            end
        end
    end

    always @(negedge clk) begin
        if (valid_out) begin
            valid_out <= 1'b0;
        end
    end
endmodule