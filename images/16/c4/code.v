module rle_encoder (
    input clk,
    input rst,
    input [7:0] data_in,
    input data_valid,
    output reg [7:0] run_length,
    output reg bit_value,
    output reg output_valid,
    output reg done
);
    reg [7:0] count;
    reg [7:0] current_value;
    reg processing;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            current_value <= 0;
            processing <= 0;
            output_valid <= 0;
            done <= 0;
        end else if (data_valid) begin
            if (!processing) begin
                current_value <= data_in; 
                count <= 1; 
                processing <= 1;
                output_valid <= 0;
                done <= 0;
            end else begin
                if (data_in == current_value) begin
                    count <= count + 1; 
                end else begin
                    run_length <= count; 
                    bit_value <= current_value; 
                    output_valid <= 1; 
                    current_value <= data_in; 
                    count <= 1; 
                end
            end
        end else if (processing) begin
            run_length <= count; 
            bit_value <= current_value; 
            output_valid <= 1; 
            done <= 1; 
            processing <= 0;
        end
    end
endmodule