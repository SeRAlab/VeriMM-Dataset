module top_module(input enable, 
                            input wire [7:0] din, 
                            input parity,
                            output busy,
                            output reg done,
                            input wire clk_div, 
                            output reg tx);parameter count = 9;

initial begin
    tx <= 1'b1;
    done = 0;
end

parameter STATE_IDLE  = 3'd0;
parameter STATE_DATA  = 3'd1;
parameter STATE_PARITY= 3'd2;
parameter STATE_STOP  = 3'd3;

reg [7:0] data = 8'b11111111;
reg [2:0] bitpos = 0;
reg [2:0] state = STATE_IDLE;
reg parity_bit;

always @(posedge clk_div) begin
    case (state)
        STATE_IDLE: begin
            done <= 0;
            tx <= 1'b1;
            if (enable & ~busy) begin
                data <= din;
                bitpos <= 0;
                parity_bit <= parity ? ~^(data) : 1'b0;
                state <= STATE_DATA;
            end
        end
        STATE_DATA: begin
            if (bitpos == count-2) begin
                tx <= parity_bit;
                state <= STATE_PARITY;
            end
            else begin
                tx <= data[bitpos];
                bitpos <= bitpos + 1;
            end
        end
        STATE_PARITY: begin
            tx <= 1'b1;
            state <= STATE_STOP;
        end
        STATE_STOP: begin
            tx <= 1'b1;
            done <= 1;
            state <= STATE_IDLE;
        end
        default: begin
            tx <= 1'b1;
            state <= STATE_IDLE;
        end
    endcase
end

assign busy = (state != STATE_IDLE);

endmodule