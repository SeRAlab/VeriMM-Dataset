module temperature_shutdown(
    input wire clk,
    input wire rst,
    input wire [7:0] temp, // 8-bit temperature input
    output reg shutdown // shutdown signal
);
    reg [2:0] count; // 3-bit counter for consecutive cycles above threshold
    parameter THRESHOLD = 8'd75;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 3'b000;
            shutdown <= 0;
        end else begin
            if (temp > THRESHOLD) begin
                if (count < 3'b101) // up to 5 counts
                    count <= count + 1;
            end else begin
                count <= 3'b000; // reset count if temp is not above threshold
            end
            
            // Activate shutdown if count reaches 5
            if (count == 3'b101) begin
                shutdown <= 1;
            end
        end
    end
endmodule