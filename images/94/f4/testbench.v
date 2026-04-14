`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg add_en;
    reg clk_d;
    reg rst;
    wire co_year;
    wire [3:0] month_m1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add_en(add_en),
        .clk_d(clk_d),
        .rst(rst),
        .co_year(co_year),
        .month_m1(month_m1)
    );

    // Clock generation (10ns period)
    initial begin
        clk_d = 0;
        forever #5 clk_d = ~clk_d;
    end

        task reset_dut;

        begin
            rst = 1;
            add_en = 0;
            @(posedge clk_d);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset initialization", test_num);
            reset_dut();
            #1;

            check_outputs(0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single increment (0 -> 1)", test_num);
            reset_dut();
            add_en = 1;
            @(posedge clk_d);
            #1;
            add_en = 0;
            #1;

            check_outputs(0, 4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: add_en disabled", test_num);
            reset_dut();
            add_en = 0;
            repeat(5) @(posedge clk_d);
            #1;
            #1;

            check_outputs(0, 4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Count up to month 12", test_num);
            reset_dut();
            add_en = 1;
            repeat(12) @(posedge clk_d);
            #1;
            add_en = 0;
            #1;

            check_outputs(0, 4'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Wrap around (12 -> 0) and co_year", test_num);
            reset_dut();
            add_en = 1;
            repeat(13) @(posedge clk_d);
            #1;
            add_en = 0;
            #1;

            check_outputs(1, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: co_year de-assertion after wrap", test_num);
            reset_dut();
            add_en = 1;
            repeat(14) @(posedge clk_d);
            #1;
            add_en = 0;
            #1;

            check_outputs(0, 4'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Asynchronous/Synchronous Reset during count", test_num);
            reset_dut();
            add_en = 1;
            repeat(5) @(posedge clk_d);
            rst = 1;
            @(posedge clk_d);
            #1;
            rst = 0;
            add_en = 0;
            #1;

            check_outputs(0, 4'd0);
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
        input expected_co_year;
        input [3:0] expected_month_m1;
        begin
            if (expected_co_year === (expected_co_year ^ co_year ^ expected_co_year) &&
                expected_month_m1 === (expected_month_m1 ^ month_m1 ^ expected_month_m1)) begin
                $display("PASS");
                $display("  Outputs: co_year=%b, month_m1=%h",
                         co_year, month_m1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: co_year=%b, month_m1=%h",
                         expected_co_year, expected_month_m1);
                $display("  Got:      co_year=%b, month_m1=%h",
                         co_year, month_m1);
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
        $dumpvars(0,add_en, clk_d, rst, co_year, month_m1);
    end

endmodule
