module ethernet_mac_controller (
    input [4:0] dest_addr,
    input [4:0] src_addr,
    input enable,
    output reg [9:0] mac_output
);
    always @(*) begin
        if (enable) begin
            mac_output = {dest_addr, src_addr}; // Concatenate destination and source addresses
        end else begin
            mac_output = 10'b0; // Set output to zero when not enabled
        end
    end
endmodule