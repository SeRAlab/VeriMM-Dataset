module top_module(
    input SER,
    input SHIFT,
    input LOAD,
    output reg [7:0] Q
);always @ (posedge SHIFT) begin
        Q <= {Q[6:0], 1'b0};
    end
    
    always @ (posedge LOAD) begin
        if (LOAD) begin
            Q <= SER;
        end
    end
    
endmodule