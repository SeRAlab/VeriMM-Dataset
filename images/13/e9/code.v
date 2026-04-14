module tcp_segmenter #(parameter MAX_SIZE = 8) (  
    input wire clk,  
    input wire reset,  
    input wire [7:0] data_in,  
    input wire valid_in,  
    output reg [7:0] data_out,  
    output reg valid_out  
);  
    reg [7:0] packet_buffer [0:MAX_SIZE-1];  
    reg [3:0] byte_count;  
    reg packet_ready;  
  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            byte_count <= 0;  
            valid_out <= 0;  
            packet_ready <= 0;  
        end else begin  
            if (valid_in && byte_count < MAX_SIZE) begin  
                packet_buffer[byte_count] <= data_in;  
                byte_count <= byte_count + 1;  
                valid_out <= 0;  
                packet_ready <= 0;  
            end  
            if (byte_count == MAX_SIZE) begin  
                data_out <= packet_buffer[0]; // Output first byte of packet  
                valid_out <= 1;  
                packet_ready <= 1;  
                byte_count <= 0;  
            end  
        end  
    end  
endmodule