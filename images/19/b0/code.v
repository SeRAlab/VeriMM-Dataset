module branch_predictor(  
    input [3:0] branch_addr,  
    input clk,  
    input rst,  
    input taken,  
    output reg prediction  
);  
    reg [1:0] counter [0:15]; // 2-bit saturating counter for 16 branches  

    // Initialize the counters  
    integer i;  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            for (i = 0; i < 16; i = i + 1) begin  
                counter[i] <= 2'b10; // Initialize to strongly taken  
            end  
        end else begin  
            // Update the prediction based on the current state of the counter  
            prediction <= (counter[branch_addr] >= 2'b10);  

            // Update the counter based on taken signal  
            if (taken) begin  
                if (counter[branch_addr] < 2'b11) begin  
                    counter[branch_addr] <= counter[branch_addr] + 1;  
                end  
            end else begin  
                if (counter[branch_addr] > 2'b00) begin  
                    counter[branch_addr] <= counter[branch_addr] - 1;  
                end  
            end  
        end  
    end  
endmodule