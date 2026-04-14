module top_module(
    input wire GCLK,    
    input wire RES,     
    inout wire CAN,     
    input wire din,     
    output reg dout,    
    output reg cntmn,   
    output reg cntmn_ready, 
    output reg sync     
    );parameter QUANTA = 20;  
    parameter SP = 15;      
    
    reg din_latch = 1'b0;    
    reg [63:0] qcnt = 64'd0; 
    
    
    reg can_sample;
    always @(posedge GCLK) begin
        can_sample <= CAN;
        
        
        if (qcnt == SP) begin
            dout <= CAN;
            cntmn_ready <= 1'b1;
            
            if (din_latch != CAN) begin
                cntmn <= 1'b1;
            end 
            else begin
                cntmn <= 1'b0;
            end
        end
        else if (qcnt < SP) begin
            cntmn_ready <= 1'b0;
        end
        
        
        else if (RES == 1'b1) begin
            dout <= 1'b0;
            cntmn <= 1'b0;
        end
        
        
        if (RES == 1'b1) begin
            qcnt <= 64'd0;
            sync <= 1'b0;
        end
        
        else if (qcnt == QUANTA) begin
            qcnt <= 64'd0;
            sync <= 1'b1; 
            cntmn <= 1'b0;
            cntmn_ready <= 1'b0;
        end 
        
        else if ((qcnt > SP) & (can_sample != dout)) begin
            qcnt <= 64'd0;
            sync <= 1'b1; 
            cntmn <= 1'b0;
            cntmn_ready <= 1'b0;
        end        
        
        else begin
            qcnt <= qcnt + 64'd1;
            sync <= 1'b0;
        end
    end
    
    
    assign CAN = (din_latch == 1'b0) ? 1'b0 : 1'bZ;
    
    always @(negedge GCLK) begin
        if (qcnt == 64'd0) begin
            din_latch <= din; 
        end
    end
    
    
endmodule