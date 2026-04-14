module temperature_shutdown (
    input wire clk,
    input wire rst,
    input wire [7:0] temp,
    input wire [7:0] threshold,
    output reg shutdown
);
    reg [2:0] state; // State to count the cycles
    reg active;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            shutdown <= 1'b0;
            state <= 3'b000;
            active <= 1'b0;
        end else begin
            if (temp > threshold) begin
                active <= 1'b1;
            end

            if (active) begin
                if (state < 3'b101) begin
                    state <= state + 1;
                end else begin
                    shutdown <= 1'b1;
                end
            end else begin
                state <= 3'b000;
                shutdown <= 1'b0;
            end
        end
    end
endmodule