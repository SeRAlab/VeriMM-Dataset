module tcp_segmenter (  
    input wire clk,  
    input wire reset,  
    input wire [31:0] data_in,  
    input wire segment,  
    output reg [15:0] segment1,  
    output reg [15:0] segment2,  
    output reg valid  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            segment1 <= 16'b0;  
            segment2 <= 16'b0;  
            valid <= 1'b0;  
        end else if (segment) begin  
            segment1 <= data_in[31:16];  
            segment2 <= data_in[15:0];  
            valid <= 1'b1;  
        end else begin  
            valid <= 1'b0;  
        end  
    end  
endmodule