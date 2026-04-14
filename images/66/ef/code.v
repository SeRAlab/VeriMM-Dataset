module shift_reg_8bit(
    input clk, 
    input rst, 
    input si, 
    output reg [7:0] po);
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            po <= 8'b00000000;
        else
            po <= {po[6:0], si};
    end
endmodule