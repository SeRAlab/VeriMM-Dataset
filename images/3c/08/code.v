module sample_rate_converter(
    input wire clk,
    input wire rst,
    input wire [7:0] input_signal,
    output reg [7:0] output_signal
);
    reg [1:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 2'b00;
            output_signal <= 8'b0;
        end else begin
            count <= count + 1;
            if (count == 2'b11) begin // Every 4 clock cycles
                output_signal <= input_signal; // Downsample by taking the last signal
            end
        end
    end
endmodule