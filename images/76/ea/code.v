module top_module(
    input clk,
    input go,
    input stop,
    input resetn,
    output reg start,
    output reg move
);reg [5:0] cur, next;

    localparam S_READY = 5'd0,
              S_READY_WAIT = 5'd1,
              S_MOVE  = 5'd2,
              S_STOP  = 5'd3;

    always @(*) begin : state_table
        case (cur)
            S_READY: next = go ? S_READY_WAIT : S_READY;
            S_READY_WAIT: next = S_MOVE;
            S_MOVE: next = stop ? S_STOP : S_MOVE;
            S_STOP: next = S_READY;
            default: next = S_READY;
        endcase
    end

    always @(*) begin : enable_signals
        start = 1'b0;
        move = 1'b0;

        case (cur) 
            S_READY: begin 
                start = 1'b1;
            end
            S_MOVE: begin 
                move = 1'b1;
            end
            default: begin
            end
        endcase    
    end

    always @(posedge clk) begin : state_FFs
        if (!resetn) begin
            cur <= S_READY;
        end else begin
            cur <= next;
        end
    end
endmodule