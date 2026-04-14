module aes_sbox (
    input [3:0] in_data,
    output reg [3:0] out_data,
    input clk,
    input rst
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            out_data <= 4'b0000; // reset output
        end else begin
            case (in_data)
                4'b0000: out_data <= 4'b1010; // example mapping
                4'b0001: out_data <= 4'b0100;
                4'b0010: out_data <= 4'b1101;
                4'b0011: out_data <= 4'b0001;
                4'b0100: out_data <= 4'b0110;
                4'b0101: out_data <= 4'b1111;
                4'b0110: out_data <= 4'b0011;
                4'b0111: out_data <= 4'b1001;
                4'b1000: out_data <= 4'b0000;
                4'b1001: out_data <= 4'b1100;
                4'b1010: out_data <= 4'b1110;
                4'b1011: out_data <= 4'b0101;
                4'b1100: out_data <= 4'b1000;
                4'b1101: out_data <= 4'b1011;
                4'b1110: out_data <= 4'b0010;
                4'b1111: out_data <= 4'b0111;
                default: out_data <= 4'b0000; // default case
            endcase
        end
    end
endmodule