module top_module(
    input clk,
    input rst,
    input req_valid,
    input [31:0] req_0,
    input [31:0] req_1,
    output reg req_ready,
    output reg res_valid,
    input res_ready,
    output reg [31:0] res_0
);// State machine states
    localparam IDLE = 2'b00;
    localparam ADD = 2'b01;
    localparam WAIT = 2'b10;
    
    // State machine register
    reg [1:0] state = IDLE;
    
    // Input register
    reg [31:0] req_0_reg;
    reg [31:0] req_1_reg;
    
    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            req_ready <= 0;
            res_valid <= 0;
            res_0 <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (req_valid && !req_ready) begin
                        req_0_reg <= req_0;
                        req_1_reg <= req_1;
                        req_ready <= 1;
                        state <= ADD;
                    end
                end
                ADD: begin
                    res_0 <= req_0_reg + req_1_reg;
                    res_valid <= 1;
                    req_ready <= 0;
                    state <= WAIT;
                end
                WAIT: begin
                    if (res_ready) begin
                        res_valid <= 0;
                        req_ready <= 0;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule