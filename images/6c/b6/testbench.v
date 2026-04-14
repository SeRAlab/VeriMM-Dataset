`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [5:0] in;
    wire [5:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 6'b0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 6'h3F;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Capture All Ones (0x3F)", test_num);
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 6'h00;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Capture All Zeros (0x00)", test_num);
            #1;

            check_outputs(6'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 6'h2A;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Capture Pattern 101010 (0x2A)", test_num);
            #1;

            check_outputs(6'h2A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 6'h15;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Capture Pattern 010101 (0x15)", test_num);
            #1;

            check_outputs(6'h15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            in = 6'h12;
            @(posedge clk);
            #2;
            $display("Testcase %0d: Capture Value 0x12", test_num);
            #1;

            check_outputs(6'h12);
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
        input [5:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
        $dumpvars(0,clk, in, out);
    end

endmodule
