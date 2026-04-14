module VMU (
    input wire clk,
    input wire reset,
    input wire [3:0] virtual_address,
    output reg [3:0] physical_address
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        physical_address <= 4'b0000; // Reset state
    end else begin
        physical_address <= virtual_address; // Direct mapping
    end
end

endmodule