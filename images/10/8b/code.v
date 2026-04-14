module temp_shutdown (
    input wire clk,
    input wire rst,
    input wire [7:0] temp_input,  // 8-bit temperature input
    output reg shutdown            // Shutdown signal
);
    parameter THRESHOLD = 8'd75;  // Shutdown threshold
    reg [1:0] exceed_count;        // Count how many cycles exceed the threshold

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shutdown <= 1'b0;
            exceed_count <= 2'b00;
        end else begin
            if (temp_input > THRESHOLD) begin
                exceed_count <= exceed_count + 1;
                if (exceed_count == 2'b11) begin // 3 consecutive cycles
                    shutdown <= 1'b1; // Activate shutdown
                end
            end else begin
                exceed_count <= 2'b00; // Reset counter if below threshold
                shutdown <= 1'b0; // Deactivate shutdown
            end
        end
    end
endmodule