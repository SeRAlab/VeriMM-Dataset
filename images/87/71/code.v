module top_module(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);parameter IDLE = 2'b00;
    parameter DETECT = 2'b01;
    parameter HOLD = 2'b10;
    
    reg [1:0] state;
    reg [31:0] out_reg;
    
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= IDLE;
            out_reg <= 0;
        end
        else begin
            case (state)
                IDLE: begin
                    out_reg <= 0;
                    if (in != 32'hFFFFFFFF) begin
                        state <= DETECT;
                    end
                end
                DETECT: begin
                    out_reg <= out_reg | (~in);
                    if (in == 32'hFFFFFFFF) begin
                        state <= HOLD;
                    end
                end
                HOLD: begin
                    out_reg <= out_reg;
                    state <= HOLD;
                end
                default: begin
                    state <= IDLE;
                    out_reg <= 0;
                end
            endcase
        end
    end
    
    assign out = out_reg;
    
endmodule