module rle_encoder (
    input clk,
    input rst,
    input data_in,
    output reg [1:0] encoded_value, // 0 for '0', 1 for '1'
    output reg [3:0] run_length // max run length of 15
);
    reg [3:0] count;
    reg current_bit;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            current_bit <= 0;
            encoded_value <= 0;
            run_length <= 0;
        end else begin
            if (data_in == current_bit) begin
                count <= count + 1;
            end else begin
                if (count > 0) begin
                    encoded_value <= current_bit;
                    run_length <= count;
                end
                count <= 1;
                current_bit <= data_in;
            end
        end
    end

    always @(posedge clk) begin
        if (count > 0) begin
            encoded_value <= current_bit;
            run_length <= count;
        end
    end
endmodule