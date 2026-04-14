module top_module(
    input clk,
    input s_in,
    output reg s_out
);reg [1:0] state; // 2-bit state variable
    parameter IDLE = 2'b00, HIGH = 2'b01, LOW = 2'b10;
    // IDLE - initial state
    // HIGH - s_in is high for 4 or more clock cycles
    // LOW - s_in is low for 4 or more clock cycles
    
    always @(posedge clk) begin
        case(state)
            IDLE: begin
                if(s_in) begin
                    state <= HIGH;
                    s_out <= 1;
                end else begin
                    state <= LOW;
                    s_out <= 0;
                end
            end
            
            HIGH: begin
                if(s_in) begin
                    s_out <= 1;
                    if(counter_high == 3) begin
                        state <= HIGH;
                    end else begin
                        counter_high <= counter_high + 1;
                        state <= HIGH;
                    end
                end else begin
                    counter_high <= 0;
                    state <= LOW;
                end
            end
            
            LOW: begin
                if(!s_in) begin
                    s_out <= 0;
                    if(counter_low == 3) begin
                        state <= LOW;
                    end else begin
                        counter_low <= counter_low + 1;
                        state <= LOW;
                    end
                end else begin
                    counter_low <= 0;
                    state <= HIGH;
                end
            end
        endcase
    end
    
    // reset counters when input signal changes
    always @(posedge clk) begin
        if(s_in != s_in_prev) begin
            counter_low <= 0;
            counter_high <= 0;
        end
        s_in_prev <= s_in;
    end
    
    // initialize variables
    integer counter_low = 0;
    integer counter_high = 0;
    reg s_in_prev = 0;
    
endmodule