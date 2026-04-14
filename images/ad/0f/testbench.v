`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_8f;
    reg reset;
    reg valid_in44;
    wire valid_inF;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_8f(clk_8f),
        .reset(reset),
        .valid_in44(valid_in44),
        .valid_inF(valid_inF)
    );

    // Clock generation (10ns period)
    initial begin
        clk_8f = 0;
        forever #5 clk_8f = ~clk_8f;
    end

        task reset_dut;

        begin
            @(negedge clk_8f);
            reset = 1;
            valid_in44 = 0;
            @(negedge clk_8f);
            reset = 0;
            @(negedge clk_8f);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying reset state...", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capturing logic HIGH...", test_num);
            reset_dut();
            @(negedge clk_8f);
            valid_in44 = 1;
            @(posedge clk_8f);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capturing logic LOW...", test_num);
            reset_dut();
            @(negedge clk_8f);
            valid_in44 = 1;
            @(posedge clk_8f);
            @(negedge clk_8f);
            valid_in44 = 0;
            @(posedge clk_8f);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset priority over input...", test_num);
            reset_dut();
            @(negedge clk_8f);
            valid_in44 = 1;
            reset = 1;
            @(posedge clk_8f);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying output stability between edges...", test_num);
            reset_dut();
            @(negedge clk_8f);
            valid_in44 = 1;
            @(posedge clk_8f);
            #2;
            @(negedge clk_8f);
            valid_in44 = 0;
            #1;
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
        input expected_valid_inF;
        begin
            if (expected_valid_inF === (expected_valid_inF ^ valid_inF ^ expected_valid_inF)) begin
                $display("PASS");
                $display("  Outputs: valid_inF=%b",
                         valid_inF);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: valid_inF=%b",
                         expected_valid_inF);
                $display("  Got:      valid_inF=%b",
                         valid_inF);
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
        $dumpvars(0,clk_8f, reset, valid_in44, valid_inF);
    end

endmodule
