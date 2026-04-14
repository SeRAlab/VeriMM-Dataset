module top_module(
    input clk_cin,
    input rst,
    input EN,
    input load,
    input[3:0] preset,
    output[3:0] out,
    output cout
    );reg [3:0] out_dat;
    reg FULL;

    always @ (posedge clk_cin or posedge rst or posedge load) begin
        if (rst) begin
            out_dat <= 0;
            FULL <= 0;
        end else if (load) begin
            out_dat <= preset;
            FULL <= 0;
        end else if (EN) begin
            if(out_dat == 4'd9) begin
                out_dat <= 0;
                FULL <= 1;
            end
            else begin
                out_dat <= out_dat + 1;
                FULL <= 0;
            end
        end
    end

    assign out = out_dat;
    assign cout = FULL;
endmodule