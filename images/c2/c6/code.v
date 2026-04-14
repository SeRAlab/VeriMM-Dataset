module memory_controller (
    input clk,
    input rst,
    input [11:0] addr,
    input we,
    input [15:0] din,
    output reg [15:0] dout,
    output reg ack
);

    reg [15:0] mem [0:4095];

    always @(posedge clk) begin
        if (rst) begin
            ack <= 0;
        end else begin
            if (we) begin
                mem[addr] <= din;
                ack <= 1;
            end else begin
                dout <= mem[addr];
                ack <= 1;
            end
        end
    end

endmodule