module top_module(clk, reset_n, start_event, window, reset_on_new_start, window_close);parameter OVL_COVER_BASIC_ON = 1;  // Changed to a local parameter
    parameter OVL_COVER_CORNER_ON = 1;  // Changed to a local parameter
    input clk, reset_n, start_event, window, reset_on_new_start;
    output reg window_close;              // Change wire to output reg
    reg [1:0] state, next_state;
    reg cover_basic, cover_corner;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= 2'b00;
            cover_basic <= 1'b0;
            cover_corner <= 1'b0;
            window_close <= 1'b0;          // Initialize window_close as well
        end else begin
            state <= next_state;
            cover_basic <= 1'b0;
            cover_corner <= 1'b0;
            case (state)
                2'b00: begin // Idle
                    if (start_event) begin
                        next_state <= 2'b01;
                    end else begin
                        next_state <= 2'b00;
                    end
                end
                2'b01: begin // Basic Cover
                    cover_basic <= 1'b1;
                    if (window == 1'b0) begin
                        next_state <= 2'b00;
                    end else if (reset_on_new_start && start_event) begin
                        next_state <= 2'b00;
                    end else begin
                        next_state <= 2'b10;
                    end
                end
                2'b10: begin // Corner Cover
                    cover_corner <= 1'b1;
                    if (window == 1'b0) begin
                        next_state <= 2'b00;
                    end else begin
                        next_state <= 2'b10;
                    end
                end
            endcase
        end
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            window_close <= 1'b0;
        end else begin
            window_close <= (window == 1'b0 && state == 2'b10);
        end
    end
    
endmodule