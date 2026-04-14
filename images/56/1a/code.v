module top_module(
    input wire [3:0] data_in,
    output wire [31:0] data_out
);reg [31:0] word;
    always @* begin
        
        word = {8{data_in}};
    end

    assign data_out = word;

endmodule