module top_module(
    input clk,
    input rst,
    output [63:0] urn
    );reg [63:0] s1 = 64'd1234;
    reg [63:0] s2 = 64'd5678;
    reg [63:0] s3 = 64'd9012;
    reg [63:0] urn_reg = 64'd0;
    wire [63:0] b1,b2,b3;
    wire [63:0] new_s1,new_s2,new_s3;
    
    assign urn = urn_reg;
    
    assign b1      = (((s1 << 13) ^ s1) >> 19);
    assign new_s1  = (((s1 & 64'hfffffffffffffffe) << 12) ^ b1);
    assign b2      = (((s2 << 2 ) ^ s2) >> 25);
    assign new_s2  = (((s2 & 64'hfffffffffffffff8) << 4 ) ^ b2);
    assign b3      = (((s3 << 3 ) ^ s3) >> 11);
    assign new_s3  = (((s3 & 64'hfffffffffffffff0) << 17) ^ b3);    
    
    always @(posedge clk)
    begin
        if (rst)
        begin
            
            s1 <= 64'd1234;
            s2 <= 64'd5678;
            s3 <= 64'd9012;
            urn_reg <= 64'd0;
        end
        else
        begin
            urn_reg <= new_s1 ^ new_s2 ^ new_s3;
            s1 <= new_s1;
            s2 <= new_s2;
            s3 <= new_s3;
        end
    end
    
endmodule