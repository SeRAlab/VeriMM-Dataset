module binary_to_bcd (
    input clk,
    input en,
    input [9:0] binary_in,
    output reg [11:0] bcd_out);

    integer i;

    always @(posedge clk) begin
        if (en) begin
            bcd_out = 12'b0;
            for (i = 9; i >= 0; i = i - 1) begin
                if (bcd_out[3:0] >= 5)
                    bcd_out[3:0] = bcd_out[3:0] + 3;
                if (bcd_out[7:4] >= 5)
                    bcd_out[7:4] = bcd_out[7:4] + 3;
                if (bcd_out[11:8] >= 5)
                    bcd_out[11:8] = bcd_out[11:8] + 3;
                bcd_out = {bcd_out[10:0], binary_in[i]};
            end
        end
    end
endmodule