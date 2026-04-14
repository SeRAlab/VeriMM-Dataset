module md5_transform (
    input wire clk,
    input wire reset,
    input wire [31:0] data_in,
    output reg [31:0] data_out
);
    reg [31:0] temp;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 32'b0;
        end else begin
            // A simple MD5-like transformation
            temp = (data_in ^ (data_in << 13)) + (data_in >> 9);
            data_out <= (temp + 32'h5A827999) ^ (temp >> 7);
        end
    end
endmodule