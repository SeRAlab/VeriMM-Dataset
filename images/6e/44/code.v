module top_module(
    input [15:0] input_signal,
    input clk,
    output reg [3:0] output_signal
);reg [3:0] count;

always @(posedge clk) begin
    if (input_signal == 16'h0000) begin
        count <= 4'h0;
    end else if (input_signal == 16'hFFFF) begin
        count <= 4'h4;
    end else begin
        if (input_signal[0] == 1'b1 && input_signal[1] == 1'b1 && input_signal[2] == 1'b1 && input_signal[3] == 1'b1) begin
            count <= 4'h4;
        end else if (input_signal[1] == 1'b1 && input_signal[2] == 1'b1 && input_signal[3] == 1'b1) begin
            count <= 4'h3;
        end else if (input_signal[2] == 1'b1 && input_signal[3] == 1'b1) begin
            count <= 4'h2;
        end else if (input_signal[3] == 1'b1) begin
            count <= 4'h1;
        end else begin
            count <= 4'h0;
        end
    end
end

assign output_signal = count;

endmodule