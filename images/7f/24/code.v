module sync_up_counter (
    input wire clk,
    input wire en,
    output reg [4:0] count
);
    
    always @(posedge clk) begin
        if (en) begin
            count <= count + 1;
        end
    end

endmodule