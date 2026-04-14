`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    reg ld;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .ld(ld),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ld = 0;
            in = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Load 4'hA");
            reset_dut();
            test_num = test_num + 1;
            in = 4'hA;
            ld = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Hold value 4'h5");
            reset_dut();
            test_num = test_num + 1;


            in = 4'h5;
            ld = 1;
            @(posedge clk);
            #1;


            ld = 0;
            in = 4'hF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Load 4'hF");
            reset_dut();
            test_num = test_num + 1;
            in = 4'hF;
            ld = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Load 4'h0");
            reset_dut();
            test_num = test_num + 1;


            in = 4'hE;
            ld = 1;
            @(posedge clk);
            #1;


            in = 4'h0;
            ld = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Complex hold behavior");
            reset_dut();
            test_num = test_num + 1;


            in = 4'h3;
            ld = 1;
            @(posedge clk);
            #1;


            ld = 0;
            in = 4'h7; @(posedge clk); #1;
            in = 4'h2; @(posedge clk); #1;
            in = 4'h9; @(posedge clk); #1;

            #1;
            #1;

            check_outputs(4'h3);
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
        input [3:0] expected_out;
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
        $dumpvars(0,clk, in, ld, out);
    end

endmodule
