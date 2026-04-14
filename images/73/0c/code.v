module top_module(
    input CLK,
    input RST,
    input EN,
    input DIR,
    output reg [7:0] CNT
    );always @(posedge CLK or negedge RST) begin
        
        if (!RST)
            
            CNT <= 0;
        else begin
            
            if (EN) begin
                
                if (DIR == 0) 
                    
                    CNT <= CNT + 1;
                 else if (DIR == 1)
                    
                    CNT <= CNT - 1;
                 else
                    
                    CNT <= CNT;                  
            end 
            
            else
                
                CNT <= CNT;      
        end
    end
    
endmodule