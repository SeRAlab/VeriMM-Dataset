module tcp_segmenter #(parameter MTU = 1500) (  
    input clk,  
    input rst_n,  
    input [7:0] data_in,  
    input data_valid,  
    output reg [7:0] packet_out,  
    output reg packet_ready  
);  
    reg [11:0] byte_count;  
    reg [7:0] packet_buffer [0:MTU-1];  
    reg [7:0] packet_index;  
    integer i;  

    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            byte_count <= 0;  
            packet_index <= 0;  
            packet_ready <= 0;  
        end else begin  
            if (data_valid) begin  
                if (byte_count < MTU) begin  
                    packet_buffer[byte_count] <= data_in;  
                    byte_count <= byte_count + 1;  
                end  
                if (byte_count == MTU - 1) begin  
                    packet_ready <= 1;  
                    for (i = 0; i < MTU; i = i + 1) begin  
                        packet_out <= packet_buffer[i];  
                        #1; // simulate time delay for output  
                    end  
                    byte_count <= 0;  
                    packet_ready <= 0;  
                end  
            end  
        end  
    end  
endmodule