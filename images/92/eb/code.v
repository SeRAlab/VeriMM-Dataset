module sync_counter_4bit_en(clk, reset, en, count);

    input  clk;  
    input  reset;  
    input  en;
    output  [3:0] count;
    reg   [3:0] count;
    initial count = 0;

    always @(posedge clk or posedge reset)
          begin
            if (reset)
                count <= 0;
            else if (en)
                count <= count + 1;
          end  

endmodule