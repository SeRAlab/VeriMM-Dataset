module PLL_8x (
    input wire clk_in,
    input wire reset,
    output reg clk_out
);
    reg [2:0] state;
    reg [2:0] counter;

    localparam IDLE = 3'b000,
               LOCKED = 3'b001;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            counter <= 0;
            clk_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (counter < 7) begin
                        counter <= counter + 1;
                    end else begin
                        state <= LOCKED;
                        counter <= 0;
                    end
                end
                LOCKED: begin
                    clk_out <= ~clk_out; // Toggle output clock
                end
            endcase
        end
    end
endmodule