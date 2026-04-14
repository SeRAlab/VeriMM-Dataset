module top_module(
    input   wire        clock,

    
    output  reg         aw_control_enable,
    input   wire        aw_control_done,

    
    output  reg         w_control_enable,
    input   wire        w_control_done,

    
    output  reg         b_control_enable,
    input   wire        b_control_done
);localparam STATE_BITS = 2;

    localparam [STATE_BITS-1:0] DO_ADDR = 'd0; 
    localparam [STATE_BITS-1:0] DO_DATA = 'd1; 
    localparam [STATE_BITS-1:0] DO_RESP = 'd2; 

    reg [STATE_BITS-1:0] state      = DO_ADDR;
    reg [STATE_BITS-1:0] state_next = DO_ADDR;




    always @(*) begin
        aw_control_enable = (state == DO_ADDR);
        w_control_enable  = (state == DO_DATA);
        b_control_enable  = (state == DO_RESP);
    end




    reg aw_done = 1'b0;
    reg w_done  = 1'b0;
    reg b_done  = 1'b0;

    always @(*) begin
        aw_done = (state == DO_ADDR) && (aw_control_done == 1'b1);
        w_done  = (state == DO_DATA) && (w_control_done  == 1'b1);
        b_done  = (state == DO_RESP) && (b_control_done  == 1'b1);
    end




    always @(*) begin
        state_next = (aw_done == 1'b1) ? DO_DATA : state;
        state_next = (w_done  == 1'b1) ? DO_RESP : state_next;
        state_next = (b_done  == 1'b1) ? DO_ADDR : state_next;
    end

    always @(posedge clock) begin
        state <= state_next;
    end

endmodule