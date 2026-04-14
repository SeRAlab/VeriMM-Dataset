module top_module(
    input wire enable_pts, 
    input wire reset_pts, 
    input wire SD_CLK, 
    input wire [31:0] signal_in, 
    output reg signal_out, 
    output reg parallel_complete
    );//internal registers and wires
    reg [8:0] counter = 0;

    always @ ( posedge SD_CLK ) begin
        if (~reset_pts) begin
            signal_out <= 0;
            counter <= 0;
            parallel_complete <= 0;
        end else begin
            if (enable_pts == 1) begin
                if (counter == 32) begin
                    parallel_complete <= 1;
                    counter <= 0;
                end else begin
                    parallel_complete <= 0;
                    signal_out = signal_in[31 - counter];
                    counter <= counter + 1;
                end
            end else begin
                signal_out <= 0;
            end
        end
    end
endmodule