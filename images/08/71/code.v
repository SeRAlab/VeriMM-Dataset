module tcp_segmenter (  
    input clk,  
    input rst,  
    input [31:0] payload_length,  // Length of the TCP payload  
    input [7:0] payload_data,     // TCP payload data  
    input start_segment,          // Signal to start segmentation  
    output reg [7:0] segment_data, // Output segmented data  
    output reg segment_valid,      // Indicates a valid segment is produced  
    output reg done                // Indicates segmentation is complete  
);  

    parameter MAX_SEGMENT_SIZE = 1500;  
    reg [31:0] current_length;  
    reg [31:0] segment_count;  
    reg [1:0] state;  

    localparam IDLE = 2'b00, SEGMENTING = 2'b01, DONE = 2'b10;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            current_length <= 0;  
            segment_count <= 0;  
            segment_valid <= 0;  
            done <= 0;  
            state <= IDLE;  
        end else begin  
            case (state)  
                IDLE: begin  
                    if (start_segment) begin  
                        current_length <= payload_length;  
                        segment_count <= 0;  
                        state <= SEGMENTING;  
                        done <= 0;  
                    end  
                end  
                SEGMENTING: begin  
                    if (current_length > 0) begin  
                        segment_data <= payload_data;  
                        segment_valid <= 1;  
                        current_length <= current_length - 1;  
                        segment_count <= segment_count + 1;  
                    end else begin  
                        segment_valid <= 0;  
                        done <= 1;  
                        state <= DONE;  
                    end  
                end  
                DONE: begin  
                    // Stay in DONE state after completion  
                end  
            endcase  
        end  
    end  
endmodule