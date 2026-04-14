module serializer (
    input clk,
    input reset,
    input [31:0] data_in,
    output reg serialized_out,
    output reg done
);
    reg [4:0] bit_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_index <= 0;
            serialized_out <= 0;
            done <= 0;
        end else if (bit_index < 32) begin
            serialized_out <= data_in[31 - bit_index];
            bit_index <= bit_index + 1;
            done <= (bit_index == 31);
        end else begin
            done <= 1; // Once we have serialized all bits, stay done
        end
    end
endmodule