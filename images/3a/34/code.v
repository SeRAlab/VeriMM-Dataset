module sd_card_controller(
    input wire clk,
    input wire reset,
    input wire [3:0] command,
    output reg ack
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ack <= 0;
        end else begin
            if (command != 4'b0000) begin // Assuming 0000 is an invalid command
                ack <= 1;
            end else begin
                ack <= 0;
            end
        end
    end
endmodule