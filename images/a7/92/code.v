module simple_fsm(
    input               clk     ,   
    input               rst_n   ,
    input               start   ,
 
    output  reg [1:0]   state
);

    // State encoding
    localparam IDLE  = 2'b00,
               START = 2'b01,
               DONE  = 2'b10;

    // FSM state transition
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE: begin
                    if (start) 
                        state <= START;
                    else 
                        state <= IDLE;
                end
                START: begin
                    state <= DONE;
                end
                DONE: begin
                    state <= DONE;
                end
                default: state <= IDLE;
            endcase
        end
    end
 
endmodule