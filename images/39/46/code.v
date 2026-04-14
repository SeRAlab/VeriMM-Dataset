module RLE_Compressor(
    input clk,
    input [7:0] data_in,
    input data_valid,
    output reg [15:0] compressed_out,
    output reg output_valid
);
    reg [7:0] current_data;
    reg [3:0] count;
    reg [1:0] state;
    
    localparam IDLE = 2'b00, COUNT = 2'b01, OUTPUT = 2'b10;

    always @(posedge clk) begin
        if (data_valid) begin
            if (state == IDLE) begin
                current_data <= data_in;
                count <= 1;
                state <= COUNT;
            end else if (state == COUNT) begin
                if (data_in == current_data) begin
                    count <= count + 1;
                end else begin
                    compressed_out <= {count, current_data};
                    output_valid <= 1;
                    current_data <= data_in;
                    count <= 1;
                    state <= COUNT;
                end
            end
        end else if (state == COUNT && count > 1) begin
            compressed_out <= {count, current_data};
            output_valid <= 1;
            state <= OUTPUT;
        end else if (state == OUTPUT) begin
            output_valid <= 0;
            state <= IDLE;
        end
    end
endmodule