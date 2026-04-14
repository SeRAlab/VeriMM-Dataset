module sd_card_controller (
    input wire clk,
    input wire [3:0] cmd,
    output reg response
);
    always @(posedge clk) begin
        if (cmd == 4'b0001) begin
            response <= 1'b1; // Respond to command 0001
        end else begin
            response <= 1'b0; // No response for other commands
        end
    end
endmodule