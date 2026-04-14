module pcie_controller (
    input wire clk,
    input wire rst,
    input wire req,
    output reg ack
);
    reg busy;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack <= 0;
            busy <= 0;
        end else begin
            if (req && !busy) begin
                ack <= 1;
                busy <= 1;
            end else if (busy) begin
                ack <= 0;
                busy <= 0;
            end
        end
    end
endmodule