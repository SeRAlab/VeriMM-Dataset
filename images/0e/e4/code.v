module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire transmit,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

    reg [7:0] buffer;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            buffer <= 8'b0;
            data_out <= 8'b0;
        end else if (transmit) begin
            buffer <= data_in;
        end else begin
            data_out <= buffer;
        end
    end
endmodule