module top_module(
    input   wire        clock,

    
    output  reg         ar_control_enable,
    input   wire        ar_control_done,

    
    output  reg        r_control_enable,
    input   wire       r_control_done
);localparam STATE_BITS = 1;

    localparam [STATE_BITS-1:0] DO_ADDR = 'd0; 
    localparam [STATE_BITS-1:0] DO_DATA = 'd1; 

    reg [STATE_BITS-1:0] state      = DO_ADDR;
    reg [STATE_BITS-1:0] state_next = DO_ADDR;




    always @(*) begin
        ar_control_enable = (state == DO_ADDR);
        r_control_enable  = (state == DO_DATA);
    end




    reg ar_done = 1'b0;
    reg r_done  = 1'b0;

    always @(*) begin
        ar_done = (state == DO_ADDR) && (ar_control_done == 1'b1);
        r_done  = (state == DO_DATA) && (r_control_done  == 1'b1);
    end




    always @(*) begin
        state_next = (ar_done == 1'b1) ? DO_DATA : state;
        state_next = (r_done  == 1'b1) ? DO_ADDR : state_next;
    end

    always @(posedge clock) begin
        state <= state_next;
    end

endmodule