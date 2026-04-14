module portfolio_optimization (
    input [4:0] allocation_in,
    output reg [4:0] allocation_out
);
    integer total;
    integer i;
    
    always @(*) begin
        total = 0;
        for (i = 0; i < 5; i = i + 1) begin
            total = total + allocation_in[i];
        end
        
        if (total > 15) begin
            for (i = 0; i < 5; i = i + 1) begin
                allocation_out[i] = (allocation_in[i] * 15) / total;
            end
        end else begin
            allocation_out = allocation_in;
        end
    end
endmodule