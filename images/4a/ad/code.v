module top_module(clk_in, clr_in, d_in, q_out);input clk_in;   
    input clr_in;   
    input d_in;     
    
    output q_out;   

    
    parameter   reg_length = 3; 
                                
    reg [reg_length - 1:0]shift_reg; 
    always @ (posedge clk_in or posedge clr_in)
begin
    if (clr_in)
    begin
    shift_reg <= 0;       
    end
    else
    begin
    shift_reg[reg_length - 1:1] <= shift_reg[reg_length - 2:0];
    shift_reg[0] <= d_in;    
    end
end

    
    assign q_out = shift_reg[reg_length - 2] & ~shift_reg[reg_length - 1];

endmodule