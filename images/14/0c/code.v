module ADC (
    input wire clk,
    input wire reset,
    input wire sample,
    input wire [2:0] control,
    output reg [7:0] output_value
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        output_value <= 8'b00000000;
    end else if (sample) begin
        output_value[control] <= 1'b1;
    end
end

endmodule