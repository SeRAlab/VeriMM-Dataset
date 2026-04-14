module noise_suppression(  
    input wire clk,  
    input wire rst,  
    input wire signal_in,  
    output reg signal_out  
);  
    reg [1:0] stable_count;  
    reg last_stable_value;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            stable_count <= 0;  
            signal_out <= 0;  
            last_stable_value <= 0;  
        end else begin  
            if (signal_in == last_stable_value) begin  
                stable_count <= stable_count + 1;  
            end else begin  
                stable_count <= 0;  
                last_stable_value <= signal_in;  
            end  
            if (stable_count >= 2) begin  
                signal_out <= last_stable_value;  
            end  
        end  
    end  
endmodule