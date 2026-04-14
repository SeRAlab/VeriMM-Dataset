module tcp_segmenter(  
    input clk,  
    input rst_n,  
    input [7:0] data_in,  
    input data_valid,  
    output reg [7:0] packet_out,  
    output reg packet_ready  
);  
    reg [2:0] byte_count;  
    reg [63:0] segment;  

    always @(posedge clk or negedge rst_n) begin  
        if (!rst_n) begin  
            byte_count <= 3'b0;  
            segment <= 64'b0;  
            packet_ready <= 1'b0;  
        end else if (data_valid) begin  
            segment <= {segment[55:0], data_in};  
            byte_count <= byte_count + 1;  
            if (byte_count == 3'b111) begin  
                packet_out <= segment[7:0];  
                segment <= 64'b0;  
                byte_count <= 3'b0;  
                packet_ready <= 1'b1;  
            end else begin  
                packet_ready <= 1'b0;  
            end  
        end  
    end  
endmodule