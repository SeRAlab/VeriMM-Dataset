`timescale 1ns/1ps

module fm_cmn_if_ff_out_tb;

    // Testbench signals (sequential circuit)
    reg clk_core;
    reg i_ack;
    reg i_ackw;
    reg [21:0] i_adrs;
    reg [3:0] i_be;
    reg [31:0] i_dbr;
    reg [31:0] i_dbw;
    reg [5:0] i_len;
    reg i_req;
    reg i_strr;
    reg i_strw;
    reg i_wr;
    reg rst_x;
    wire o_ack;
    wire o_ackw;
    wire [21:0] o_adrs;
    wire [3:0] o_be;
    wire [31:0] o_dbr;
    wire [31:0] o_dbw;
    wire [5:0] o_len;
    wire o_req;
    wire o_strr;
    wire o_strw;
    wire o_wr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fm_cmn_if_ff_out dut (
        .clk_core(clk_core),
        .i_ack(i_ack),
        .i_ackw(i_ackw),
        .i_adrs(i_adrs),
        .i_be(i_be),
        .i_dbr(i_dbr),
        .i_dbw(i_dbw),
        .i_len(i_len),
        .i_req(i_req),
        .i_strr(i_strr),
        .i_strw(i_strw),
        .i_wr(i_wr),
        .rst_x(rst_x),
        .o_ack(o_ack),
        .o_ackw(o_ackw),
        .o_adrs(o_adrs),
        .o_be(o_be),
        .o_dbr(o_dbr),
        .o_dbw(o_dbw),
        .o_len(o_len),
        .o_req(o_req),
        .o_strr(o_strr),
        .o_strw(o_strw),
        .o_wr(o_wr)
    );

    // Clock generation (10ns period)
    initial begin
        clk_core = 0;
        forever #5 clk_core = ~clk_core;
    end

        task reset_dut;

        begin
            rst_x = 0;
            i_ack = 0;
            i_ackw = 0;
            i_adrs = 0;
            i_be = 0;
            i_dbr = 0;
            i_dbw = 0;
            i_len = 0;
            i_req = 0;
            i_strr = 0;
            i_strw = 0;
            i_wr = 0;
            repeat(2) @(posedge clk_core);
            #1 rst_x = 1;
            repeat(1) @(posedge clk_core);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Reset State Check");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 0, 22'h0, 4'h0, 32'h0, 32'h0, 6'h0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Write Request Check");
            test_num = 2;
            reset_dut();

            @(posedge clk_core);
            i_req  = 1;
            i_wr   = 1;
            i_adrs = 22'h1A2B3C;
            i_len  = 6'd4;
            i_be   = 4'hF;
            i_dbw  = 32'hDEADBEEF;
            i_strw = 1;

            @(posedge clk_core);
            #1;
            #1;

            check_outputs(0, 0, 22'h1A2B3C, 4'hF, 0, 32'hDEADBEEF, 6'd4, 1, 0, 1, 1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: Read Request Check");
            test_num = 3;
            reset_dut();

            @(posedge clk_core);
            i_req  = 1;
            i_wr   = 0;
            i_adrs = 22'h0001FF;
            i_len  = 6'd8;

            @(posedge clk_core);
            #1;
            #1;

            check_outputs(0, 0, 22'h0001FF, 0, 0, 0, 6'd8, 1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: Read Data and Acknowledge Check");
            test_num = 4;
            reset_dut();

            @(posedge clk_core);
            i_ack  = 1;
            i_strr = 1;
            i_dbr  = 32'hCAFEBABE;

            @(posedge clk_core);
            #1;
            #1;

            check_outputs(1, 0, 0, 0, 32'hCAFEBABE, 0, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Write Completion Check");
            test_num = 5;
            reset_dut();

            @(posedge clk_core);
            i_ackw = 1;
            i_ack  = 1;

            @(posedge clk_core);
            #1;
            #1;

            check_outputs(1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Partial Byte Enable Check");
            test_num = 6;
            reset_dut();

            @(posedge clk_core);
            i_req  = 1;
            i_wr   = 1;
            i_be   = 4'b1001;
            i_dbw  = 32'hAAAA_5555;

            @(posedge clk_core);
            #1;
            #1;

            check_outputs(0, 0, 0, 4'b1001, 0, 32'hAAAA_5555, 0, 1, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning testcase007: Boundary Values Check");
            test_num = 7;
            reset_dut();

            @(posedge clk_core);
            i_adrs = 22'h3FFFFF;
            i_len  = 6'h3F;
            i_be   = 4'hF;
            i_dbw  = 32'hFFFFFFFF;
            i_dbr  = 32'hFFFFFFFF;

            @(posedge clk_core);
            #1;
            #1;

            check_outputs(0, 0, 22'h3FFFFF, 4'hF, 32'hFFFFFFFF, 32'hFFFFFFFF, 6'h3F, 0, 0, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fm_cmn_if_ff_out Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_o_ackw;
        input [21:0] expected_o_adrs;
        input [3:0] expected_o_be;
        input [31:0] expected_o_dbr;
        input [31:0] expected_o_dbw;
        input [5:0] expected_o_len;
        input expected_o_req;
        input expected_o_strr;
        input expected_o_strw;
        input expected_o_wr;
        begin
            if (expected_o_ack === (expected_o_ack ^ o_ack ^ expected_o_ack) &&
                expected_o_ackw === (expected_o_ackw ^ o_ackw ^ expected_o_ackw) &&
                expected_o_adrs === (expected_o_adrs ^ o_adrs ^ expected_o_adrs) &&
                expected_o_be === (expected_o_be ^ o_be ^ expected_o_be) &&
                expected_o_dbr === (expected_o_dbr ^ o_dbr ^ expected_o_dbr) &&
                expected_o_dbw === (expected_o_dbw ^ o_dbw ^ expected_o_dbw) &&
                expected_o_len === (expected_o_len ^ o_len ^ expected_o_len) &&
                expected_o_req === (expected_o_req ^ o_req ^ expected_o_req) &&
                expected_o_strr === (expected_o_strr ^ o_strr ^ expected_o_strr) &&
                expected_o_strw === (expected_o_strw ^ o_strw ^ expected_o_strw) &&
                expected_o_wr === (expected_o_wr ^ o_wr ^ expected_o_wr)) begin
                $display("PASS");
                $display("  Outputs: o_ack=%b, o_ackw=%b, o_adrs=%h, o_be=%h, o_dbr=%h, o_dbw=%h, o_len=%h, o_req=%b, o_strr=%b, o_strw=%b, o_wr=%b",
                         o_ack, o_ackw, o_adrs, o_be, o_dbr, o_dbw, o_len, o_req, o_strr, o_strw, o_wr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_ack=%b, o_ackw=%b, o_adrs=%h, o_be=%h, o_dbr=%h, o_dbw=%h, o_len=%h, o_req=%b, o_strr=%b, o_strw=%b, o_wr=%b",
                         expected_o_ack, expected_o_ackw, expected_o_adrs, expected_o_be, expected_o_dbr, expected_o_dbw, expected_o_len, expected_o_req, expected_o_strr, expected_o_strw, expected_o_wr);
                $display("  Got:      o_ack=%b, o_ackw=%b, o_adrs=%h, o_be=%h, o_dbr=%h, o_dbw=%h, o_len=%h, o_req=%b, o_strr=%b, o_strw=%b, o_wr=%b",
                         o_ack, o_ackw, o_adrs, o_be, o_dbr, o_dbw, o_len, o_req, o_strr, o_strw, o_wr);
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
        $dumpvars(0,clk_core, i_ack, i_ackw, i_adrs, i_be, i_dbr, i_dbw, i_len, i_req, i_strr, i_strw, i_wr, rst_x, o_ack, o_ackw, o_adrs, o_be, o_dbr, o_dbw, o_len, o_req, o_strr, o_strw, o_wr);
    end

endmodule
