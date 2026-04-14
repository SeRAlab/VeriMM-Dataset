module sd_card_controller (
    input clk,
    input start,
    input stop,
    output reg busy
);
    always @(posedge clk) begin
        if (start) begin
            busy <= 1'b1; // Card is busy
        end else if (stop) begin
            busy <= 1'b0; // Card is ready
        end
    end
endmodule