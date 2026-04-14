module RLE(
    input clk,
    input reset,
    input valid,
    input data,
    output reg [7:0] count,
    output reg bit_value,
    output reg ready
);
    reg [7:0] current_count;
    reg current_value;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            bit_value <= 0;
            ready <= 0;
            current_count <= 0;
            current_value <= 0;
        end else if (valid) begin
            if (current_count == 0) begin
                current_value <= data;
                current_count <= 1;
            end else if (data == current_value) begin
                current_count <= current_count + 1;
            end else begin
                count <= current_count;
                bit_value <= current_value;
                ready <= 1;
                current_value <= data;
                current_count <= 1;
            end
        end
    end
endmodule