module sliding_window_protocol #(parameter WINDOW_SIZE = 4, parameter NUM_PACKETS = 8) (  
    input clk,  
    input reset,  
    input ack,  
    output reg [NUM_PACKETS-1:0] sent_packets,  
    output reg [NUM_PACKETS-1:0] acknowledged_packets,  
    output reg [1:0] current_window  
);  

    integer i;  
    reg [1:0] next_window;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            sent_packets <= 0;  
            acknowledged_packets <= 0;  
            current_window <= 0;  
        end else begin  
            // Send new packet if within window size  
            if (current_window < WINDOW_SIZE) begin  
                sent_packets[current_window] <= 1;  
                current_window <= current_window + 1;  
            end  
            // Acknowledge received packets  
            if (ack) begin  
                acknowledged_packets[current_window - 1] <= 1;  
                current_window <= current_window - 1;  
            end  
        end  
    end  
endmodule