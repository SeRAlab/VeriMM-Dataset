`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bin;
    reg clk;
    reg sreset;
    wire gray;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .clk(clk),
        .sreset(sreset),
        .gray(gray)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sreset = 1;
            bin = 0;
            @(posedge clk);
            #1;
            sreset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = 1; @(posedge clk); #1;
            bin = 0; @(posedge clk); #1;
            bin = 1; @(posedge clk); #1;
            bin = 1; #1;
            $display("Testcase %0d: Input 1011, checking last bit...", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = 0; @(posedge clk); #1;
            bin = 1; @(posedge clk); #1;
            bin = 1; @(posedge clk); #1;
            bin = 0; #1;
            $display("Testcase %0d: Input 0110, checking last bit...", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = 1; @(posedge clk); #1;
            bin = 1; @(posedge clk); #1;
            bin = 1; @(posedge clk); #1;
            bin = 1; #1;
            $display("Testcase %0d: Input 1111, checking last bit...", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = 0; @(posedge clk); #1;
            bin = 0; @(posedge clk); #1;
            bin = 0; @(posedge clk); #1;
            bin = 0; #1;
            $display("Testcase %0d: Input 0000, checking last bit...", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = 1; #1;
            $display("Testcase %0d: Input 1, checking last bit...", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = 1; @(posedge clk); #1;
            bin = 0; #1;
            $display("Testcase %0d: Input 10, checking last bit...", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = 0; @(posedge clk); #1;
            bin = 0; @(posedge clk); #1;
            bin = 0; @(posedge clk); #1;
            bin = 1; #1;
            $display("Testcase %0d: Input 0001, checking last bit...", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = 1; @(posedge clk); #1;
            bin = 1; @(posedge clk); #1;
            bin = 0; #1;
            $display("Testcase %0d: Input 110, checking last bit...", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            bin = 1; @(posedge clk); #1;
            bin = 0; @(posedge clk); #1;
            bin = 1; @(posedge clk); #1;
            bin = 0; @(posedge clk); #1;
            bin = 1; #1;
            $display("Testcase %0d: Input 10101, checking last bit...", test_num);
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
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        input expected_gray;
        begin
            if (expected_gray === (expected_gray ^ gray ^ expected_gray)) begin
                $display("PASS");
                $display("  Outputs: gray=%b",
                         gray);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray=%b",
                         expected_gray);
                $display("  Got:      gray=%b",
                         gray);
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
        $dumpvars(0,bin, clk, sreset, gray);
    end

endmodule
