module top_module(
    
    input [15:0] extendee,
    input ExtSel,
    
    output reg[31:0] result
    );integer i;
    
    

    always @(ExtSel or extendee) begin
            for(i = 0; i < 16; i = i + 1) begin
                result[i] <= extendee[i];
            end 
            
            if(ExtSel) begin
                for(i = 16; i < 32; i = i + 1) begin
                    result[i] = extendee[15];
                end 
            end else begin 
                for(i = 16; i < 32; i = i + 1) begin
                    result[i] = 0;
                end
            end
    end

endmodule