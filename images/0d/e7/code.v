module sample_rate_converter(
    input clk,
    input rst,
    input [3:0] in_signal,
    output reg [1:0] out_signal
);

reg [1:0] count;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 2'b00;
        out_signal <= 2'b00;
    end else begin
        count <= count + 1;
        if (count == 2'b01) begin
            out_signal <= in_signal[3:2]; // take the two MSBs of the input
        end
    end
end

endmodule