module top_module(clk,rst_n,out_50Hz,out_50Hz_pulse);input clk,rst_n;
output reg out_50Hz,out_50Hz_pulse;

reg [31:0] counter;

always @ (posedge clk or negedge rst_n)
    if (!rst_n) begin
        out_50Hz_pulse <= 0;
        out_50Hz <= 0;
        counter <= 0;
    end
    else begin   
        if (counter >= 32'd1_999_999) begin
            counter <= 0;
            out_50Hz_pulse <= 1;
            out_50Hz <= 1;
        end
        else begin
            if (counter < 32'd1_000_000)        out_50Hz <= 1;
            else if (counter < 32'd2_000_000)   out_50Hz <= 0;
            counter <= counter + 1;
            out_50Hz_pulse <= 0;
        end
    end
        
endmodule