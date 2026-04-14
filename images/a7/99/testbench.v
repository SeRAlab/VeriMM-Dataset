`timescale 1ns/1ps

module Counter_12_tc_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    wire [11:0] Q;
    wire tc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Counter_12_tc dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .Q(Q),
        .tc(tc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        rst = 1;
        en = 0;
        @(negedge clk);
        rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Verify Reset State");
        reset_dut();

        #1;


        check_outputs(12'h000, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Basic Counting (5 increments)");
        reset_dut();
        @(negedge clk);
        en = 1;
        repeat (5) @(negedge clk);
        en = 0;

        #1;


        check_outputs(12'h005, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Verify Enable Logic (Counter holds when en=0)");
        reset_dut();
        @(negedge clk);
        en = 1;
        repeat (10) @(negedge clk);
        en = 0;
        repeat (10) @(negedge clk);

        #1;


        check_outputs(12'h00A, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Verify Terminal Count at 4095");
        reset_dut();
        @(negedge clk);
        en = 1;

        repeat (4095) @(negedge clk);
        en = 0;

        #1;


        check_outputs(12'hFFF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Verify Rollover (4095 -> 0)");
        reset_dut();
        @(negedge clk);
        en = 1;

        repeat (4096) @(negedge clk);
        en = 0;

        #1;


        check_outputs(12'h000, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Reset Priority Over Enable");
        reset_dut();
        @(negedge clk);
        en = 1;
        repeat (20) @(negedge clk);

        rst = 1;
        @(negedge clk);
        rst = 0;
        en = 0;

        #1;


        check_outputs(12'h000, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Incrementing after middle-run reset");
        reset_dut();
        @(negedge clk);
        en = 1;
        repeat (100) @(negedge clk);
        rst = 1;
        @(negedge clk);
        rst = 0;
        repeat (50) @(negedge clk);
        en = 0;
        #1;

        check_outputs(12'h032, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Counter_12_tc Testbench");
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
        input [11:0] expected_Q;
        input expected_tc;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_tc === (expected_tc ^ tc ^ expected_tc)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, tc=%b",
                         Q, tc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, tc=%b",
                         expected_Q, expected_tc);
                $display("  Got:      Q=%h, tc=%b",
                         Q, tc);
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
        $dumpvars(0,clk, en, rst, Q, tc);
    end

endmodule
