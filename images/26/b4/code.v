module sample_rate_converter(  
    input clk,  
    input reset,  
    input [7:0] din,  
    input din_valid,  
    output reg [7:0] dout,  
    output reg dout_valid  
);  
    reg [2:0] count;  
    reg [7:0] buffer [0:7];  
    reg [2:0] read_ptr, write_ptr;  
    reg fifo_full;  
    reg fifo_empty;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            count <= 0;  
            read_ptr <= 0;  
            write_ptr <= 0;  
            dout <= 0;  
            dout_valid <= 0;  
            fifo_full <= 0;  
            fifo_empty <= 1;  
        end else begin  
            if (din_valid && !fifo_full) begin  
                buffer[write_ptr] <= din;  
                write_ptr <= (write_ptr + 1) % 8;  
                fifo_empty <= 0;  
                if (write_ptr == (read_ptr - 1) % 8)  
                    fifo_full <= 1;  
            end  
  
            if (count == 2) begin  
                dout <= buffer[read_ptr];  
                dout_valid <= 1;  
                read_ptr <= (read_ptr + 1) % 8;  
                count <= 0;  
                if (read_ptr == write_ptr)  
                    fifo_empty <= 1;  
                fifo_full <= 0;  
            end else begin  
                dout_valid <= 0;  
                count <= count + 1;  
            end  
        end  
    end  
endmodule