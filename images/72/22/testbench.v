`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clkin;
    reg reset;
    wire [7:0] count;
    wire tc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clkin(clkin),
        .reset(reset),
        .count(count),
        .tc(tc)
    );

    // Clock generation (10ns period)
    initial begin
        clkin = 0;
        forever #5 clkin = ~clkin;
    end

        task reset_dut;

        begin
            reset = 1;
            #15;
            reset = 0;
            @(posedge clkin);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Count after 1 cycle", test_num);
            reset_dut();


            #1;



            check_outputs(8'h01, 0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("\nTestcase %0d: Reach BCD 09", test_num);
            reset_dut();

            repeat(8) @(posedge clkin);
            #1;
            #1;

            check_outputs(8'h09, 0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("\nTestcase %0d: BCD Rollover 09 -> 10", test_num);
            reset_dut();

            repeat(9) @(posedge clkin);
            #1;
            #1;

            check_outputs(8'h10, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: BCD Rollover 19 -> 20", test_num);
            reset_dut();

            repeat(19) @(posedge clkin);
            #1;
            #1;

            check_outputs(8'h20, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Reach terminal count 23", test_num);
            reset_dut();

            repeat(22) @(posedge clkin);
            #1;
            #1;

            check_outputs(8'h23, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Rollover 23 -> 00", test_num);
            reset_dut();

            repeat(23) @(posedge clkin);
            #1;
            #1;

            check_outputs(8'h00, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Full cycle (24) + 5 cycles", test_num);
            reset_dut();

            repeat(28) @(posedge clkin);
            #1;
            #1;

            check_outputs(8'h05, 0);
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
        input [7:0] expected_count;
        input expected_tc;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_tc === (expected_tc ^ tc ^ expected_tc)) begin
                $display("PASS");
                $display("  Outputs: count=%h, tc=%b",
                         count, tc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, tc=%b",
                         expected_count, expected_tc);
                $display("  Got:      count=%h, tc=%b",
                         count, tc);
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
        $dumpvars(0,clkin, reset, count, tc);
    end

endmodule
