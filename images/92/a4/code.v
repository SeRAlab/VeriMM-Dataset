module load_register(clk, reset, load, data_in, data_out);  

    input  clk;  
    input  reset;  
    input  load;  
    input  [15:0] data_in;  
    output  [15:0] data_out;  
    reg   [15:0] data_out; 
    initial data_out = 0;

    always @(posedge clk)
        begin
            if (reset)
                data_out <= 0;
            else if (load)
                data_out <= data_in;
        end  

endmodule