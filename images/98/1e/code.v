module top_module(
    input in1_0,
    input in1_1,
    input in2_0,
    input in2_1,
    input sel0,
    input sel1,
    output reg q0,
    output reg q1,
    input req,
    output reg ack,
    input clk // Added clk as an input to resolve errors
);reg [1:0] data;

    always @(posedge req) begin
        if(sel0) begin
            data <= {in1_1, in1_0}; // Removed explicit indexing since data is already 2 bits wide
        end else if(sel1) begin
            data <= {in2_1, in2_0}; // Removed explicit indexing since data is already 2 bits wide
        end
    end
    
    always @(posedge clk) begin
        q0 <= data[1];
        q1 <= data[0];
    end
    
    always @(posedge clk) begin
        ack <= 1'b0;
        if(req) begin
            ack <= 1'b1;
        end
    end

endmodule