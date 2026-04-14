module top_module(
    output q,
    input d,
    input en,
    input clk
);reg out;
    assign q = out;

    
    
    always @(posedge clk) begin
        if(en) begin
            out <= d;
        end
    end

endmodule