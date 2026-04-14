module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    input wire data_in_valid,
    output reg [7:0] data_out,
    output reg data_out_valid,
    input wire [7:0] received_data,
    input wire received_data_valid
);

    reg [7:0] transmission_buffer;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
            data_out_valid <= 0;
            transmission_buffer <= 8'b0;
        end else begin
            if (data_in_valid) begin
                transmission_buffer <= data_in;
                data_out <= transmission_buffer;
                data_out_valid <= 1;
            end else begin
                data_out_valid <= 0;
            end

            if (received_data_valid) begin
                // Here you can handle the received data as needed
            end
        end
    end
endmodule