`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg ctrl;
    reg dir;
    reg reset;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .ctrl(ctrl),
        .dir(dir),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            ce = 0;
            dir = 0;
            ctrl = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Increment (Step 1)", test_num);
            reset_dut();
            ce = 1;
            dir = 0;
            ctrl = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Increment (Step 2)", test_num);
            reset_dut();
            ce = 1;
            dir = 0;
            ctrl = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Basic Decrement (Step 1)", test_num);
            reset_dut();
            ce = 1;
            dir = 1;
            ctrl = 1;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Basic Decrement (Step 2)", test_num);
            reset_dut();
            ce = 1;
            dir = 1;
            ctrl = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Clock Enable Check", test_num);
            reset_dut();
            ce = 0;
            dir = 0;
            ctrl = 1;
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Wrap-around Increment", test_num);
            reset_dut();
            ce = 1;
            dir = 0;
            ctrl = 1;
            repeat(16) @(posedge clk);
            #1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Mixed Operation", test_num);
            reset_dut();
            ce = 1;


            dir = 0;
            ctrl = 0;
            repeat(4) @(posedge clk);


            dir = 1;
            ctrl = 1;
            repeat(3) @(posedge clk);

            #1;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Step 2 Boundary Wrap", test_num);
            reset_dut();
            ce = 1;
            dir = 1;
            ctrl = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Max Value Check", test_num);
            reset_dut();
            ce = 1;
            dir = 0;
            ctrl = 1;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Intermittent Enable", test_num);
            reset_dut();
            dir = 0;
            ctrl = 1;

            ce = 1; @(posedge clk);
            ce = 0; @(posedge clk);
            ce = 1; @(posedge clk);
            ce = 0; @(posedge clk);

            #1;
            #1;

            check_outputs(4'd2);
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
        testcase010();
        
        
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
        $dumpvars(0,ce, clk, ctrl, dir, reset, out);
    end

endmodule
