module top_module(
    clk,
    reset_n,
    in, // detector input
    out, // detector output
    edge_detect // specifies whether rising or falling edge it to detect
);parameter DEL = 1; // delay parameter
    
    input clk;
    input reset_n;
    input in;
    input edge_detect;
    output reg out;
    
    reg latch;
    reg prev_in;
    
    always @(posedge clk or negedge reset_n) begin
        if (~reset_n) begin
            out <= #DEL 1'b0;
            latch <= #DEL 1'b0;
        end else begin
            // update latch with input signal
            latch <= #DEL in;
            
            if (edge_detect == 1) begin
                // detect rising edge
                if (prev_in == 0 && in == 1) begin
                    out <= #DEL 1'b1;
                end else begin
                    out <= #DEL 1'b0;
                end
            end else begin
                // detect falling edge
                if (prev_in == 1 && in == 0) begin
                    out <= #DEL 1'b1;
                end else begin
                    out <= #DEL 1'b0;
                end
            end
            
            // store current input signal for next cycle
            prev_in <= #DEL in;
        end
    end

endmodule