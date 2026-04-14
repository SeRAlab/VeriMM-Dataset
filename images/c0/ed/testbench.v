`timescale 1ns/1ps

module a25_wishbone_buf_tb;

    // Testbench signals (sequential circuit)
    reg i_accepted;
    reg [31:0] i_addr;
    reg [15:0] i_be;
    reg i_clk;
    reg [127:0] i_rdata;
    reg i_rdata_valid;
    reg i_req;
    reg [127:0] i_wdata;
    reg i_write;
    wire o_ack;
    wire [31:0] o_addr;
    wire [15:0] o_be;
    wire [127:0] o_rdata;
    wire o_valid;
    wire [127:0] o_wdata;
    wire o_write;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    a25_wishbone_buf dut (
        .i_accepted(i_accepted),
        .i_addr(i_addr),
        .i_be(i_be),
        .i_clk(i_clk),
        .i_rdata(i_rdata),
        .i_rdata_valid(i_rdata_valid),
        .i_req(i_req),
        .i_wdata(i_wdata),
        .i_write(i_write),
        .o_ack(o_ack),
        .o_addr(o_addr),
        .o_be(o_be),
        .o_rdata(o_rdata),
        .o_valid(o_valid),
        .o_wdata(o_wdata),
        .o_write(o_write)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_accepted    <= 1'b0;
            i_addr        <= 32'h0;
            i_be          <= 16'h0;
            i_rdata       <= 128'h0;
            i_rdata_valid <= 1'b0;
            i_req         <= 1'b0;
            i_wdata       <= 128'h0;
            i_write       <= 1'b0;
            @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Idle State Check");
            reset_dut();


            #1;



            check_outputs(
                1'b0,
                32'h0,
                16'h0,
                128'h0,
                1'b0,
                128'h0,
                1'b0
            );
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Write Request (Immediate)");
            reset_dut();

            @(posedge i_clk);
            i_req   <= 1'b1;
            i_write <= 1'b1;
            i_addr  <= 32'hA0A0A0A0;
            i_wdata <= 128'h11112222333344445555666677778888;
            i_be    <= 16'hFFFF;
            i_accepted <= 1'b1;

            @(posedge i_clk);
            #1;
            i_req   <= 1'b0;
            i_accepted <= 1'b0;



            #1;




            check_outputs(1'b1, 32'hA0A0A0A0, 16'hFFFF, 128'h0, 1'b1, 128'h11112222333344445555666677778888, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Single Read Request");
            reset_dut();

            @(posedge i_clk);
            i_req   <= 1'b1;
            i_write <= 1'b0;
            i_addr  <= 32'hB0B0B0B0;

            @(posedge i_clk);
            #1;
            i_req   <= 1'b0;
            i_accepted <= 1'b1;

            @(posedge i_clk);
            #1;
            i_accepted <= 1'b0;
            i_rdata <= 128'hCAFEBABEDEADBEEFCAFEBABEDEADBEEF;
            i_rdata_valid <= 1'b1;

            @(posedge i_clk);
            #1;


            #1;



            check_outputs(1'b1, 32'hB0B0B0B0, 16'h0, 128'hCAFEBABEDEADBEEFCAFEBABEDEADBEEF, 1'b0, 128'h0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Write Buffering (2 Slots)");
            reset_dut();


            @(posedge i_clk);
            i_req   <= 1'b1;
            i_write <= 1'b1;
            i_addr  <= 32'h11111111;
            i_wdata <= 128'hD1D1D1D1D1D1D1D1D1D1D1D1D1D1D1D1;
            i_be    <= 16'h00FF;
            i_accepted <= 1'b0;

            @(posedge i_clk);
            #1;

            i_addr  <= 32'h22222222;
            i_wdata <= 128'hD2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2;
            i_be    <= 16'hFF00;

            @(posedge i_clk);
            #1;
            i_req <= 1'b0;


            i_accepted <= 1'b1;
            @(posedge i_clk);
            #1;



            #1;




            check_outputs(1'b1, 32'h22222222, 16'hFF00, 128'h0, 1'b1, 128'hD2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Write followed by Read");
            reset_dut();


            @(posedge i_clk);
            i_req   <= 1'b1;
            i_write <= 1'b1;
            i_addr  <= 32'hCCCC0000;
            i_wdata <= 128'h5555AAAA5555AAAA5555AAAA5555AAAA;
            i_accepted <= 1'b1;

            @(posedge i_clk);
            #1;

            i_write <= 1'b0;
            i_addr  <= 32'hDDDD0000;
            i_accepted <= 1'b1;

            @(posedge i_clk);
            #1;
            i_req <= 1'b0;
            i_rdata <= 128'hEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE;
            i_rdata_valid <= 1'b1;

            @(posedge i_clk);
            #1;


            #1;



            check_outputs(1'b1, 32'hDDDD0000, 16'h0, 128'hEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE, 1'b0, 128'h0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("a25_wishbone_buf Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input expected_o_ack;
        input [31:0] expected_o_addr;
        input [15:0] expected_o_be;
        input [127:0] expected_o_rdata;
        input expected_o_valid;
        input [127:0] expected_o_wdata;
        input expected_o_write;
        begin
            if (expected_o_ack === (expected_o_ack ^ o_ack ^ expected_o_ack) &&
                expected_o_addr === (expected_o_addr ^ o_addr ^ expected_o_addr) &&
                expected_o_be === (expected_o_be ^ o_be ^ expected_o_be) &&
                expected_o_rdata === (expected_o_rdata ^ o_rdata ^ expected_o_rdata) &&
                expected_o_valid === (expected_o_valid ^ o_valid ^ expected_o_valid) &&
                expected_o_wdata === (expected_o_wdata ^ o_wdata ^ expected_o_wdata) &&
                expected_o_write === (expected_o_write ^ o_write ^ expected_o_write)) begin
                $display("PASS");
                $display("  Outputs: o_ack=%b, o_addr=%h, o_be=%h, o_rdata=%h, o_valid=%b, o_wdata=%h, o_write=%b",
                         o_ack, o_addr, o_be, o_rdata, o_valid, o_wdata, o_write);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_ack=%b, o_addr=%h, o_be=%h, o_rdata=%h, o_valid=%b, o_wdata=%h, o_write=%b",
                         expected_o_ack, expected_o_addr, expected_o_be, expected_o_rdata, expected_o_valid, expected_o_wdata, expected_o_write);
                $display("  Got:      o_ack=%b, o_addr=%h, o_be=%h, o_rdata=%h, o_valid=%b, o_wdata=%h, o_write=%b",
                         o_ack, o_addr, o_be, o_rdata, o_valid, o_wdata, o_write);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,i_accepted, i_addr, i_be, i_clk, i_rdata, i_rdata_valid, i_req, i_wdata, i_write, o_ack, o_addr, o_be, o_rdata, o_valid, o_wdata, o_write);
    end

endmodule
