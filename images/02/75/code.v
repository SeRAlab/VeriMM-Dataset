module serializer_32bit (
    input clk,
    input rst,
    input [31:0] data_in,
    input start,
    output reg serial_out,
    output reg valid,
    output reg done
);
    reg [5:0] count; // Counts from 0 to 31 (32 bits)
    reg [31:0] temp_data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            serial_out <= 0;
            valid <= 0;
            done <= 0;
            temp_data <= 0;
        end else if (start) begin
            temp_data <= data_in;
            count <= 0;
            valid <= 1;
            done <= 0;
        end else if (valid) begin
            serial_out <= temp_data[count]; // Output the bit
            count <= count + 1;
            if (count == 31) begin
                valid <= 0;
                done <= 1;
            end
        end
    end
endmodule