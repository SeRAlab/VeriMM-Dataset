module shift_register(clk, reset, data_out);  

    input  clk;  
    input  reset;  
    output  [2:0] data_out;  
    reg   [2:0] data_out; 
    initial data_out = 0;

    always @(posedge clk)
        begin
            if (reset)
                data_out <= 0;
            else
                data_out <= data_out << 1;
        end  

endmodule