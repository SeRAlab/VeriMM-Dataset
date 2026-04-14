module clock_divider(
    input               clk_in      ,   
    input               rst         ,
    input       [7:0]   div_factor  ,
 
    output  reg         clk_out
);

    reg [7:0] counter;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_out <= 0;
        end
        else begin
            if (counter >= div_factor - 1) begin
                counter <= 0;
                clk_out <= ~clk_out;
            end
            else begin
                counter <= counter + 1;
            end
        end
    end

endmodule