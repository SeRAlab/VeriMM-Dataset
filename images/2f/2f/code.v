module nvme_command_processor(
    input wire clk,
    input wire reset,
    input wire [3:0] command,
    output reg valid,
    output reg ready
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            valid <= 0;
            ready <= 0;
        end else begin
            if (command != 4'b0000) begin // Assuming 0 is an invalid command
                valid <= 1;
                ready <= ~ready; // Toggle ready signal on valid command
            end else begin
                valid <= 0;
            end
        end
    end
endmodule