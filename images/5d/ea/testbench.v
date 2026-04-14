`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg cmm_err_tlp_posted;
    reg decr_cpl;
    reg rst;
    wire [2:0] cpl_num;
    wire inc_dec_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .cmm_err_tlp_posted(cmm_err_tlp_posted),
        .decr_cpl(decr_cpl),
        .rst(rst),
        .cpl_num(cpl_num),
        .inc_dec_b(inc_dec_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        cmm_err_tlp_posted = 0;
        decr_cpl = 0;
        repeat(2) @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial Reset State", test_num);
        reset_dut();

        #1;


        check_outputs(3'b000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single Increment", test_num);
        reset_dut();
        cmm_err_tlp_posted = 1;
        @(posedge clk);
        #1 cmm_err_tlp_posted = 0;
        @(posedge clk);

        #1;


        check_outputs(3'b001, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Increment to 3", test_num);
        reset_dut();
        cmm_err_tlp_posted = 1;
        repeat(3) @(posedge clk);
        #1 cmm_err_tlp_posted = 0;
        @(posedge clk);

        #1;


        check_outputs(3'b011, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Underflow Check (0 to 7)", test_num);
        reset_dut();
        decr_cpl = 1;
        @(posedge clk);
        #1 decr_cpl = 0;
        @(posedge clk);

        #1;


        check_outputs(3'b111, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Inc and Dec Sequence", test_num);
        reset_dut();
        cmm_err_tlp_posted = 1;
        @(posedge clk);
        #1 cmm_err_tlp_posted = 0;
        decr_cpl = 1;
        @(posedge clk);
        #1 decr_cpl = 0;
        @(posedge clk);

        #1;


        check_outputs(3'b000, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Overflow Check (7 to 0)", test_num);
        reset_dut();
        cmm_err_tlp_posted = 1;
        repeat(8) @(posedge clk);
        #1 cmm_err_tlp_posted = 0;
        @(posedge clk);

        #1;


        check_outputs(3'b000, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Simultaneous Signals (No change or Priority)", test_num);
        reset_dut();
        cmm_err_tlp_posted = 1;
        decr_cpl = 1;
        @(posedge clk);
        #1 cmm_err_tlp_posted = 0;
        decr_cpl = 0;
        @(posedge clk);

        #1;


        check_outputs(3'b000, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [2:0] expected_cpl_num;
        input expected_inc_dec_b;
        begin
            if (expected_cpl_num === (expected_cpl_num ^ cpl_num ^ expected_cpl_num) &&
                expected_inc_dec_b === (expected_inc_dec_b ^ inc_dec_b ^ expected_inc_dec_b)) begin
                $display("PASS");
                $display("  Outputs: cpl_num=%h, inc_dec_b=%b",
                         cpl_num, inc_dec_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cpl_num=%h, inc_dec_b=%b",
                         expected_cpl_num, expected_inc_dec_b);
                $display("  Got:      cpl_num=%h, inc_dec_b=%b",
                         cpl_num, inc_dec_b);
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
        $dumpvars(0,clk, cmm_err_tlp_posted, decr_cpl, rst, cpl_num, inc_dec_b);
    end

endmodule
