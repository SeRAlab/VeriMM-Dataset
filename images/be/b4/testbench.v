`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk1k;
    reg sw;
    wire r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk1k(clk1k),
        .sw(sw),
        .r(r)
    );

    // Clock generation (10ns period)
    initial begin
        clk1k = 0;
        forever #5 clk1k = ~clk1k;
    end

        task reset_dut;

        begin
            sw = 0;
            repeat(4) @(posedge clk1k);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Rising Edge Detection (0->1)", test_num);
            @(negedge clk1k);
            sw = 1;
            @(posedge clk1k);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Test %0d: Steady High State (r should return to 0)", test_num);
            @(negedge clk1k);
            sw = 1;
            @(posedge clk1k);
            @(posedge clk1k);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Steady Low State", test_num);
            @(negedge clk1k);
            sw = 0;
            repeat(2) @(posedge clk1k);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Falling Edge Detection (1->0)", test_num);

            @(negedge clk1k);
            sw = 1;
            @(posedge clk1k);

            @(negedge clk1k);
            sw = 0;
            @(posedge clk1k);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Consecutive Rising Edges", test_num);

            @(negedge clk1k);
            sw = 1;
            @(posedge clk1k);
            @(negedge clk1k);
            sw = 0;
            @(posedge clk1k);

            @(negedge clk1k);
            sw = 1;
            @(posedge clk1k);
            #2;
            #1;

            check_outputs(1'b1);
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
        input expected_r;
        begin
            if (expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: r=%b",
                         r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r=%b",
                         expected_r);
                $display("  Got:      r=%b",
                         r);
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
        $dumpvars(0,clk1k, sw, r);
    end

endmodule
