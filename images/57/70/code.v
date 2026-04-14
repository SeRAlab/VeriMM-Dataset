module top_module(
    input clk,
    input ena,
    input rst,
    input dstrb,
    input signed [11:0] din,
    output reg signed [11:0] dout, // Change net to reg
    output reg douten              // Change net to reg
);reg signed [11:0] prev_dc;
    reg signed [11:0] cur_dc;
    reg signed [11:0] diff;

    always @(posedge clk) begin
        if (rst) begin
            prev_dc <= 0;
            cur_dc <= 0;
            diff <= 0;
            douten <= 0;
            dout <= 0;                // Initialize dout on reset
        end else if (ena) begin
            // Update current DC component
            if (dstrb) begin
                cur_dc <= din;
            end
            
            // Calculate differential signal
            diff <= cur_dc - prev_dc;
            prev_dc <= cur_dc;
            
            // Output differential signal
            if (dstrb) begin
                dout <= diff;
                douten <= 1;
            end else begin
                douten <= 0;
            end
        end
    end
    
endmodule