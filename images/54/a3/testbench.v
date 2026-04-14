`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clkin;
    reg reset;
    wire clkoutn;
    wire clkoutp;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clkin(clkin),
        .reset(reset),
        .clkoutn(clkoutn),
        .clkoutp(clkoutp)
    );

    // Clock generation (10ns period)
    initial begin
        clkin = 0;
        forever #5 clkin = ~clkin;
    end

        task reset_dut;

        begin
            reset = 1;
            #20;
            reset = 0;
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking Reset State", test_num);
            reset = 1;
            #25;
            #1;

            check_outputs(1'b0, 1'b0);
            reset = 0;
            #10;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking First Transition", test_num);
            reset_dut();
            @(posedge clkin);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking Second Transition", test_num);
            reset_dut();
            @(posedge clkin);
            @(posedge clkin);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking Complementary Signal at Cycle 3", test_num);
            reset_dut();
            @(posedge clkin);
            @(posedge clkin);
            @(posedge clkin);
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Checking Stability after 4 cycles", test_num);
            reset_dut();
            repeat(4) @(posedge clkin);
            #1;

            #1;


            check_outputs(1'b1, 1'b0);
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
        input expected_clkoutn;
        input expected_clkoutp;
        begin
            if (expected_clkoutn === (expected_clkoutn ^ clkoutn ^ expected_clkoutn) &&
                expected_clkoutp === (expected_clkoutp ^ clkoutp ^ expected_clkoutp)) begin
                $display("PASS");
                $display("  Outputs: clkoutn=%b, clkoutp=%b",
                         clkoutn, clkoutp);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clkoutn=%b, clkoutp=%b",
                         expected_clkoutn, expected_clkoutp);
                $display("  Got:      clkoutn=%b, clkoutp=%b",
                         clkoutn, clkoutp);
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
        $dumpvars(0,clkin, reset, clkoutn, clkoutp);
    end

endmodule
