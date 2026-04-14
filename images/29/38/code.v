module sata_controller (
    input wire clk,
    input wire start,
    input wire stop,
    output reg state // 0 for IDLE, 1 for ACTIVE
);
    always @(posedge clk) begin
        if (start)
            state <= 1'b1; // Move to ACTIVE state
        else if (stop)
            state <= 1'b0; // Move to IDLE state
    end
endmodule