module gpio_controller (
    input wire [3:0] data_in,
    input wire write_enable,
    input wire reset,
    output reg [3:0] data_out
);

    always @(posedge write_enable or posedge reset) begin
        if (reset) begin
            data_out <= 4'b0000;
        end else begin
            data_out <= data_in;
        end
    end
endmodule