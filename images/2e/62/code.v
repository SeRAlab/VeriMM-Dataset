module pipeline_adder(
    input clk,
    input rst,
    input [7:0] data_a,
    input [7:0] data_b,
    output reg [7:0] result
);
    reg [7:0] stage1_fetch;
    reg [7:0] stage2_decode_a;
    reg [7:0] stage2_decode_b;
    reg [7:0] stage3_execute;
    reg [7:0] stage4_memory;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stage1_fetch <= 8'b0;
            stage2_decode_a <= 8'b0;
            stage2_decode_b <= 8'b0;
            stage3_execute <= 8'b0;
            stage4_memory <= 8'b0;
            result <= 8'b0;
        end else begin
            // Fetch stage
            stage1_fetch <= data_a; // Simulating fetching data_a
            
            // Decode stage
            stage2_decode_a <= stage1_fetch; // Simulating decoding data_a
            stage2_decode_b <= data_b; // Simulating fetching data_b
            
            // Execute stage
            stage3_execute <= stage2_decode_a + stage2_decode_b; // Simulating addition
            
            // Memory stage (not used, just passing through)
            stage4_memory <= stage3_execute; 
            
            // WriteBack stage
            result <= stage4_memory; // Writing back the result
        end
    end
endmodule