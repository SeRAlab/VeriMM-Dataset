`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg rclk;
    reg rrst_n;
    reg [9:0] wptr;
    wire [9:0] rq2_wptr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rclk(rclk),
        .rrst_n(rrst_n),
        .wptr(wptr),
        .rq2_wptr(rq2_wptr)
    );

    // Clock generation (10ns period)
    initial begin
        rclk = 0;
        forever #5 rclk = ~rclk;
    end

        task reset_dut;

    begin
        rrst_n = 1'b0;
        wptr = 10'b0;
        #20;
        rrst_n = 1'b1;
        repeat (2) @(posedge rclk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Checking reset state...", test_num);
        reset_dut();

        #1;


        check_outputs(10'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Basic single value synchronization (0x1FF)...", test_num);
        reset_dut();
        wptr = 10'h1FF;

        @(posedge rclk);
        @(posedge rclk);
        #2;
        #1;

        check_outputs(10'h1FF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Checking synchronization of all bits high (0x3FF)...", test_num);
        reset_dut();
        wptr = 10'h3FF;
        @(posedge rclk);
        @(posedge rclk);
        #2;
        #1;

        check_outputs(10'h3FF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Verifying 2-stage pipeline latency...", test_num);
        reset_dut();
        wptr = 10'h2AA;
        @(posedge rclk);
        #2;
        if (rq2_wptr === 10'h000) begin
            $display("  Cycle 1: Output correctly remained 0");
            @(posedge rclk);
            #2;
            #1;

            check_outputs(10'h2AA);
        end else begin
            $display("  Cycle 1: FAIL - Output changed too early!");
            fail_count = fail_count + 1;
        end
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Rapidly changing input stability...", test_num);
        reset_dut();
        wptr = 10'h055;
        @(posedge rclk);
        wptr = 10'h0AA;
        @(posedge rclk);
        #2;
        #1;

        check_outputs(10'h055);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Asynchronous reset during operation...", test_num);
        reset_dut();
        wptr = 10'h35A;
        @(posedge rclk);
        rrst_n = 1'b0;
        #5;
        #1;

        check_outputs(10'h000);
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
        input [9:0] expected_rq2_wptr;
        begin
            if (expected_rq2_wptr === (expected_rq2_wptr ^ rq2_wptr ^ expected_rq2_wptr)) begin
                $display("PASS");
                $display("  Outputs: rq2_wptr=%h",
                         rq2_wptr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rq2_wptr=%h",
                         expected_rq2_wptr);
                $display("  Got:      rq2_wptr=%h",
                         rq2_wptr);
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
        $dumpvars(0,rclk, rrst_n, wptr, rq2_wptr);
    end

endmodule
