module top_module(
    input clk,
    input reset,
    input [3:0] in0,
    input [3:0] in1,
    input mode,
    output reg eq,
    output reg gt,
    output reg lt,
    output reg [3:0] final_output
);reg [3:0] add_sub_out;
    reg [3:0] comp_out;
    
    // Adder-Subtractor Circuit
    always @(posedge clk) begin
        if (reset) begin
            add_sub_out <= 4'b0;
        end else begin
            if (mode) begin // Subtraction
                add_sub_out <= in0 - in1;
            end else begin // Addition
                add_sub_out <= in0 + in1;
            end
        end
    end
    
    // 4-bit Comparator
    always @(*) begin
        if (add_sub_out == 4'b0000) begin
            eq <= 1'b1;
            gt <= 1'b0;
            lt <= 1'b0;
        end else if (add_sub_out > 4'b0000) begin
            eq <= 1'b0;
            gt <= 1'b1;
            lt <= 1'b0;
        end else begin
            eq <= 1'b0;
            gt <= 1'b0;
            lt <= 1'b1;
        end
    end
    
    // Final Output Generator
    always @(*) begin
        if (eq) begin
            final_output <= 4'b0000;
        end else if (gt) begin
            final_output <= add_sub_out + comp_out;
        end else begin
            final_output <= add_sub_out - comp_out;
        end
    end
    
    // Asynchronous Reset for Comparator
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            comp_out <= 4'b0000;
        end else begin
            comp_out <= 4'b1111;
        end
    end

endmodule