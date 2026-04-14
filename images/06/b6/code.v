module fifo_queue #(parameter WIDTH = 8, DEPTH = 4) (  
    input clk,  
    input wr_en,  
    input rd_en,  
    input [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] data_out,  
    output reg empty,  
    output reg full  
);  
    reg [WIDTH-1:0] fifo [0:DEPTH-1];  
    reg [2:0] read_ptr, write_ptr, count;  

    always @(posedge clk) begin  
        if (wr_en && !full) begin  
            fifo[write_ptr] <= data_in;  
            write_ptr <= (write_ptr + 1) % DEPTH;  
            count <= count + 1;  
        end  
        
        if (rd_en && !empty) begin  
            data_out <= fifo[read_ptr];  
            read_ptr <= (read_ptr + 1) % DEPTH;  
            count <= count - 1;  
        end  

        empty <= (count == 0);  
        full <= (count == DEPTH);  
    end  
endmodule