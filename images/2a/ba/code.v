module sample_rate_converter(clk_in, clk_out, reset, data_in, data_out, valid_out);  
    input clk_in, clk_out, reset;  
    input [15:0] data_in;  
    output reg [15:0] data_out;  
    output reg valid_out;  

    reg [15:0] fifo [0:1];  
    reg [1:0] write_ptr, read_ptr;  
    reg [1:0] count;  

    always @(posedge clk_in or posedge reset) begin  
        if (reset) begin  
            write_ptr <= 0;  
            count <= 0;  
            valid_out <= 0;  
        end else if (count < 2) begin  
            fifo[write_ptr] <= data_in;  
            write_ptr <= write_ptr + 1;  
            count <= count + 1;  
        end  
    end  

    always @(posedge clk_out or posedge reset) begin  
        if (reset) begin  
            read_ptr <= 0;  
            valid_out <= 0;  
        end else if (count > 0) begin  
            data_out <= fifo[read_ptr];  
            read_ptr <= read_ptr + 1;  
            count <= count - 1;  
            valid_out <= 1;  
        end else begin  
            valid_out <= 0;  
        end  
    end  
endmodule