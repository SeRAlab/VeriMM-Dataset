module register_32bit
    (
        input rst_n,
        input clk,
        input load,
        input [31:0] data_in,
        output reg [31:0] data_out
    );

    reg [31:0] reg_data;

    always @(posedge clk) 
    begin
        if (!rst_n)
            reg_data <= 32'd0;
        else if (load)
            reg_data <= data_in;
    end

    always @(posedge clk)
    begin
        data_out <= reg_data;
    end

endmodule