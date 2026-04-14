module gpio_controller(
    input wire [4:0] data_in,
    input wire enable,
    output reg [4:0] data_out
);
    always @(posedge enable) begin
        if (enable) begin
            data_out <= data_in;
        end
    end
endmodule