`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] acc_in;
    reg clk;
    reg ld;
    reg reset;
    wire [7:0] acc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .acc_in(acc_in),
        .clk(clk),
        .ld(ld),
        .reset(reset),
        .acc_out(acc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            ld = 0;
            acc_in = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Load Operation (0xA5)", test_num);
            reset_dut();
            @(negedge clk);
            ld = 1;
            acc_in = 8'hA5;
            @(negedge clk);
            ld = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify Hold Functionality", test_num);
            reset_dut();

            @(negedge clk);
            ld = 1;
            acc_in = 8'h55;
            @(negedge clk);

            ld = 0;
            acc_in = 8'hFF;
            @(negedge clk);

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Successive Load Operations", test_num);
            reset_dut();
            @(negedge clk);
            ld = 1;
            acc_in = 8'h11;
            @(negedge clk);
            acc_in = 8'h22;
            @(negedge clk);
            acc_in = 8'h33;
            @(negedge clk);
            ld = 0;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority over Load", test_num);
            reset_dut();
            @(negedge clk);
            ld = 1;
            acc_in = 8'hFF;
            reset = 1;
            @(negedge clk);
            ld = 0;
            reset = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Min/Max Values", test_num);
            reset_dut();
            @(negedge clk);
            ld = 1;
            acc_in = 8'hFF;
            @(negedge clk);
            acc_in = 8'h00;
            @(negedge clk);
            ld = 0;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_acc_out;
        begin
            if (expected_acc_out === (expected_acc_out ^ acc_out ^ expected_acc_out)) begin
                $display("PASS");
                $display("  Outputs: acc_out=%h",
                         acc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: acc_out=%h",
                         expected_acc_out);
                $display("  Got:      acc_out=%h",
                         acc_out);
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
        $dumpvars(0,acc_in, clk, ld, reset, acc_out);
    end

endmodule
