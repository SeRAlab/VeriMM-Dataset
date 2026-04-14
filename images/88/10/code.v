module top_module( 
    input wire clk,
    input wire reset,
    input wire [254:0] in,
    input wire [2:0] vec,
    output wire [10:0] out,
    output wire [2:0] outv,
    output wire o2,
    output wire o1,
    output wire o0 );// Binary counter module
    reg [7:0] count = 0;
    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
        end else begin
            if (in == 255) begin
                count <= 8'b11111111;
            end else begin
                count <= count + 1;
            end
        end
    end
    
    // Input splitter module
    assign outv = vec;
    assign o2 = vec[2];
    assign o1 = vec[1];
    assign o0 = vec[0];
    
    // Final output module
    assign out = {count, vec};
    
endmodule