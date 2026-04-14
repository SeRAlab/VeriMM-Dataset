module top_module(
input clk,
input [7:0]random_num,
output reg [15:0]password
    );reg [7:0]count = 8'd11;  
    integer div_count = 0;
    reg div_clk = 0;
    
    always@(posedge clk) begin
        password[15:8] = random_num;
        password[7:0] = count;
    end
    
    always@(posedge clk) begin
        if(div_count == 11) begin
            div_count <= 0;
            div_clk <= ~div_clk;
            end
        else div_count <= div_count + 1;
    end
    
    always@(posedge div_clk) begin
        if(count == 8'hff) count = 8'd11;
        else count = count + 1;
    end
endmodule