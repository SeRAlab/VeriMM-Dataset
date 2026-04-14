module top_module(
    input_0,input_1,choose_bit,next
    );parameter width = 32;
    input wire[width-1:0] input_0;
    input wire[width-1:0] input_1;
    input wire choose_bit;
    output reg[width-1:0] next;
 always @(*) begin 
    if(choose_bit == 1)
    begin
         next = input_1;
    end
    else 
    begin
         next = input_0;
    end   
end

endmodule