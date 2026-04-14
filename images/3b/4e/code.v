module pcie_endpoint_controller(
    input clk,
    input reset,
    input req,
    input [7:0] address,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg ready
);
    reg [7:0] memory [0:255]; // Simple memory
    reg [7:0] current_address;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ready <= 1'b0;
            data_out <= 8'b0;
        end else begin
            ready <= 1'b1;
            current_address <= address;

            if (req) begin // Write operation
                memory[current_address] <= data_in;
            end else begin // Read operation
                data_out <= memory[current_address];
            end
        end
    end
endmodule