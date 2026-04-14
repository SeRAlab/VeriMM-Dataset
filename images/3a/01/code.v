module fifo_queue #(parameter DEPTH = 8, parameter WIDTH = 8) (  
    input clk,  
    input rst,  
    input wr_en,  
    input rd_en,  
    input [WIDTH-1:0] data_in,  
    output reg [WIDTH-1:0] data_out,  
    output reg full,  
    output reg empty  
);  

    reg [WIDTH-1:0] fifo [0:DEPTH-1];  
    reg [3:0] write_ptr;  
    reg [3:0] read_ptr;  
    reg [3:0] count;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            write_ptr <= 0;  
            read_ptr <= 0;  
            count <= 0;  
            full <= 0;  
            empty <= 1;  
        end else begin  
            // Write operation  
            if (wr_en && !full) begin  
                fifo[write_ptr] <= data_in;  
                write_ptr <= (write_ptr + 1) % DEPTH;  
                count <= count + 1;  
            end  
            // Read operation  
            if (rd_en && !empty) begin  
                data_out <= fifo[read_ptr];  
                read_ptr <= (read_ptr + 1) % DEPTH;  
                count <= count - 1;  
            end  
            // Update full and empty flags  
            full <= (count == DEPTH);  
            empty <= (count == 0);  
        end  
    end  
endmodule