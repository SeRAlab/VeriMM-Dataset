module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);reg [99:0] stage1_data;
reg [99:0] stage2_data;
reg [99:0] stage3_data;

always @(posedge clk) begin
    if(load) begin
        stage1_data <= data;
        stage2_data <= stage1_data;
        stage3_data <= stage2_data;
        q <= stage3_data;
    end else begin
        stage1_data <= q;
        if(ena == 2'b01) begin
            stage2_data[99] <= stage1_data[0]; // Corrected part
            stage2_data[98:1] <= stage1_data[99:2]; // Corrected part
        end else if(ena == 2'b10) begin
            stage2_data[98:0] <= stage1_data[99:1]; // Corrected part
            stage2_data[99] <= stage1_data[0]; // Corrected part
        end else if(ena == 2'b11) begin
            stage2_data[99] <= stage1_data[1]; // Corrected part
            stage2_data[98] <= stage1_data[99]; // Corrected part
            stage2_data[97:0] <= stage1_data[98:0]; // Corrected part
        end else begin
            stage2_data <= stage1_data;
        end
        
        if(ena == 2'b01 || ena == 2'b10 || ena == 2'b11) begin
            stage3_data[99] <= stage2_data[0]; // Corrected part
            stage3_data[98:1] <= stage2_data[99:2]; // Corrected part
        end else begin
            stage3_data <= stage2_data;
        end
        q <= stage3_data;
    end
end

endmodule