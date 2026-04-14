module top_module(
    input clk,
    input reset,
    input signed [31:0] in,
    output [39:0] out
);reg [39:0] bcd_out;
    reg [31:0] temp_in;
    reg [3:0] nibble;
    reg [4:0] i;
    
    always @ (posedge clk) begin
        if (reset) begin
            bcd_out <= 40'b0;
            temp_in <= 32'd0;
            nibble <= 4'd0;
            i <= 5'd0;
        end else begin
            temp_in <= in;
            bcd_out <= 40'b0;
            for (i = 0; i < 32; i = i + 1) begin
                nibble <= nibble + (temp_in[i] << 3);
                nibble <= nibble + (temp_in[i] << 2);
                nibble <= nibble + (temp_in[i] << 1);
                if (nibble >= 10) begin
                    nibble <= nibble + 6;
                end
                bcd_out[i+7] <= nibble;
                nibble <= 4'd0;
            end
        end
    end
    
    assign out = bcd_out;
    
endmodule