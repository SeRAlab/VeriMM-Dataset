module reset_controller (
    input wire clk,
    input wire rst_n,
    output reg reset_out
);
    reg [1:0] state;

    localparam IDLE = 2'b00;
    localparam ACTIVE = 2'b01;
    localparam DEBOUNCE = 2'b10;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= ACTIVE;
        end else begin
            case (state)
                ACTIVE: begin
                    reset_out <= 0;
                    if (rst_n) begin
                        state <= IDLE;
                    end
                end
                IDLE: begin
                    reset_out <= 1;
                    if (!rst_n) begin
                        state <= ACTIVE;
                    end
                end
            endcase
        end
    end
endmodule