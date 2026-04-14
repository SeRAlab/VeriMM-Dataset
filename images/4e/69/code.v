module top_module(
    input clk,
    input reset,
    output reg [1:0] state,
    output reg myevent,
    output reg myevent_pending
);reg [1:0] next_state;
    reg [1:0] current_state;
    
    always @(posedge clk) begin
        if (reset) begin
            current_state <= 2'b00;
            myevent <= 1'b0;
            myevent_pending <= 1'b0;
        end
        else begin
            current_state <= next_state;
            myevent <= 1'b0;
            myevent_pending <= 1'b0;
        end
    end
    
    always @* begin
        case(current_state)
            2'b00: next_state = 2'b01;
            2'b01: next_state = 2'b10;
            2'b10: next_state = 2'b00;
        endcase
    end
    
    assign state = current_state;
    
    always @* begin
        if (current_state == 2'b10) begin
            myevent <= 1'b1;
        end
        else if (current_state == 2'b01) begin
            myevent_pending <= 1'b1;
        end
    end

endmodule