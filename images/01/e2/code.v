module sd_card_controller (
    input wire clk,
    input wire reset,
    input wire rw,
    input wire [3:0] addr,
    input wire [15:0] data_in,
    output reg [15:0] data_out,
    output reg ready
);
    reg [15:0] memory [0:15]; // 16x16-bit memory

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ready <= 0;
            data_out <= 16'b0;
        end else begin
            if (rw) begin
                // Write operation
                memory[addr] <= data_in;
                ready <= 1; // Operation complete
            end else begin
                // Read operation
                data_out <= memory[addr];
                ready <= 1; // Operation complete
            end
        end
    end
endmodule