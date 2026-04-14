module top_module( input clk
    , input data
    , output reg key_pressed
    , output reg [7:0] last_pressed
    );reg [21:0] data_register;
        
    always @(negedge clk) begin
        if (data_register[12:2] == 11'b11111100000) begin
            last_pressed <= data_register[21:14];
            key_pressed <= 1;
            data_register <= 0;
        end
        else begin
            key_pressed <= 0;
            data_register <= {data, data_register[21:1]};

        end
        
    end
endmodule