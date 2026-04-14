module eth_mac_controller (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg valid
);
    reg [7:0] buffer;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            buffer <= 8'b0;
            data_out <= 8'b0;
            valid <= 0;
        end else if (enable) begin
            buffer <= data_in;
            data_out <= buffer + 8'd1; // Process data (increment)
            valid <= 1; // Output is valid
        end else begin
            valid <= 0; // Output is not valid when not enabled
        end
    end
endmodule