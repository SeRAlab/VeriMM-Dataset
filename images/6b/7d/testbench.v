`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg sw;
    wire deb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sw(sw),
        .deb(deb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sw = 0;
            #(20 * 10);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simple Low to High transition", test_num);
            reset_dut();
            sw = 1;
            #(200 * 10);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Glitch suppression (Short pulse ignored)", test_num);
            reset_dut();
            sw = 1;
            #(2 * 10);
            sw = 0;
            #(200 * 10);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition Low to High with bouncing", test_num);
            reset_dut();

            sw = 1; #20;
            sw = 0; #15;
            sw = 1; #25;
            sw = 0; #10;
            sw = 1;
            #(200 * 10);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simple High to Low transition", test_num);
            reset_dut();

            sw = 1;
            #(200 * 10);

            sw = 0;
            #(200 * 10);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: High-state glitch suppression", test_num);
            reset_dut();

            sw = 1;
            #(200 * 10);

            sw = 0;
            #(3 * 10);
            sw = 1;
            #(200 * 10);
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
        input expected_deb;
        begin
            if (expected_deb === (expected_deb ^ deb ^ expected_deb)) begin
                $display("PASS");
                $display("  Outputs: deb=%b",
                         deb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: deb=%b",
                         expected_deb);
                $display("  Got:      deb=%b",
                         deb);
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
        $dumpvars(0,clk, sw, deb);
    end

endmodule
