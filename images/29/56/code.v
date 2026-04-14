module i2c_controller (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg start,
    output reg stop
);
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            start <= 0;
            stop <= 0;
            state <= 2'b00;
        end else begin
            case (state)
                2'b00: begin
                    if (enable) begin
                        start <= 1;
                        state <= 2'b01;
                    end
                end
                2'b01: begin
                    if (!enable) begin
                        stop <= 1;
                        state <= 2'b10;
                    end
                end
                2'b10: begin
                    if (!enable) begin
                        stop <= 0;
                        state <= 2'b00;
                    end else begin
                        start <= 0;
                    end
                end
            endcase
        end
    end
endmodule