module serializer(
    input wire clk,
    input wire rst,
    input wire start,
    input wire [31:0] parallel_in,
    output reg serial_out,
    output reg done
);
    reg [4:0] count; // 5 bits to count from 0 to 31
    reg [31:0] data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            serial_out <= 0;
            done <= 0;
        end else if (start) begin
            data <= parallel_in;
            count <= 0;
            done <= 0;
        end else if (count < 32) begin
            serial_out <= data[31]; // output the highest bit
            data <= {data[30:0], 1'b0}; // shift left
            count <= count + 1;
            if (count == 31) begin
                done <= 1; // serialization done
            end
        end
    end
endmodule