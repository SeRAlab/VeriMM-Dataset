module top_module(
    input [31:0] data_in,
    input [6:0] ecc_in,
    input tag_in,
    input valid_in,
    input control_tag_in,
    input error_in,
    input dequeue_in,
    input por_req_in,
    input clk,
    input reset,
    output [31:0] data_out,
    output [6:0] ecc_out,
    output tag_out,
    output valid_out,
    output control_tag_out,
    output error_out,
    output dequeue_out,
    output por_req_out
);reg [31:0] data_reg;
reg [6:0] ecc_reg;
reg tag_reg;
reg valid_reg;
reg control_tag_reg;
reg error_reg;
reg dequeue_reg;
reg por_req_reg;

always @(posedge clk) begin
    if (reset) begin
        data_reg <= 0;
        ecc_reg <= 0;
        tag_reg <= 0;
        valid_reg <= 0;
        control_tag_reg <= 0;
        error_reg <= 0;
        dequeue_reg <= 0;
        por_req_reg <= 1;
    end else begin
        if (por_req_in) begin
            por_req_reg <= 0;
        end
        if (control_tag_in) begin
            control_tag_reg <= 1;
        end else if (dequeue_in) begin
            control_tag_reg <= 0;
        end
        if (valid_in) begin
            data_reg <= data_in;
            ecc_reg <= ecc_in;
            tag_reg <= tag_in;
            valid_reg <= 1;
        end
        if (dequeue_in) begin
            valid_reg <= 0;
            dequeue_reg <= 1;
        end
        if (error_in) begin
            error_reg <= 1;
        end
    end
end

assign data_out = data_reg;
assign ecc_out = ecc_reg;
assign tag_out = tag_reg;
assign valid_out = valid_reg;
assign control_tag_out = control_tag_reg;
assign error_out = error_reg;
assign dequeue_out = dequeue_reg;
assign por_req_out = por_req_reg;

endmodule