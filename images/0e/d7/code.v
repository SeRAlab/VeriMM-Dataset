module gpio_controller (
    input wire [7:0] input_data,
    input wire read_en,
    input wire write_en,
    input wire reset,
    output reg [7:0] output_data
);

always @(posedge reset or posedge write_en or posedge read_en) begin
    if (reset) begin
        output_data <= 8'b0;
    end else if (write_en) begin
        output_data <= input_data;
    end
end

endmodule