module top_module(
    input  A1, 
    input  A2, 
    input  A3, 
    input  B1, 
    input  B2, 
    input  reset, 
    input  enable, 
    input  VPB, 
    input  VPWR, 
    input  VGND, 
    input  VNB, 
    output X,
    output overflow
);reg X_reg;
    assign overflow = (A1&A2&A3&B1&B2)>1;
    
    always @(posedge enable or posedge reset) begin
        if (reset) begin
            X_reg <= 0;
        end else if (enable) begin
            X_reg <= A1&A2&A3&B1&B2;
        end
    end
    
    assign X = X_reg;
    
endmodule