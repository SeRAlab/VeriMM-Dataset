module ethernet_mac_controller (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] data_in,
    output reg status
);
    reg [7:0] buffer;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            status <= 0;
            buffer <= 8'b0;
        end else if (enable) begin
            buffer <= data_in;
            status <= 1; // Data received
        end else begin
            status <= 0; // No data
        end
    end
endmodule