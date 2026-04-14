module gpio_controller (
    input wire clk,
    input wire enable,
    input wire [4:0] write_data,
    input wire read_enable,
    output reg [4:0] read_data
);
    reg [4:0] pins;

    always @(posedge clk) begin
        if (enable) begin
            pins <= write_data;
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            read_data <= pins;
        end
    end
endmodule