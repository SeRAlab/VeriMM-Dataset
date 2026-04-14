module top_module(
    input clk, resetn, din_valid,
    input [7:0] din00, din01, din02,
    input [7:0] din10, din11, din12,
    input [7:0] din20, din21, din22,
    output reg [7:0] dout,
    output reg dout_valid
    );reg [7:0] sum;
    reg [3:0] count;
    
    always @(posedge clk, negedge resetn) begin
        if (!resetn) begin
            dout_valid <= 0;
            dout <= 0;
            sum <= 0;
            count <= 0;
        end else begin
            if (din_valid) begin
                sum <= din00 + din01 + din02 + din10 + din11 + din12 + din20 + din21 + din22;
                count <= 9;
                dout <= sum / count;
                dout_valid <= 1;
            end else begin
                dout_valid <= 0;
                dout <= 0;
                sum <= 0;
                count <= 0;
            end
        end
    end

endmodule