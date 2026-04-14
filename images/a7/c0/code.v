module top_module(
    input clk,
    input slowena,
    input reset,
    input sel1,
    input sel2,
    output reg [3:0] q  // Changed 'output' to 'output reg'
);reg [3:0] input_signal;
    reg [3:0] count;
    reg enable;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            enable <= 0;
            q <= 0; // Initialize q to 0 on reset
        end else if (slowena) begin
            enable <= 1;
        end else if (count == 9) begin
            count <= 0;
        end else if (enable) begin
            count <= count + 1;    
        end
    end

    always @(*) begin
        if (sel1 == 0 && sel2 == 0) begin
            input_signal = 4'b0001;
        end else if (sel1 == 0 && sel2 == 1) begin
            input_signal = 4'b0010;
        end else if (sel1 == 1 && sel2 == 0) begin
            input_signal = 4'b0100;
        end else if (sel1 == 1 && sel2 == 1) begin
            input_signal = 4'b1000;
        end
        q = count; // Update q based on the count
    end

endmodule