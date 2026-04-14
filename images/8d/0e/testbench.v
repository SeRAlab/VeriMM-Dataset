`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    reg reset;
    wire [31:0] count;
    wire dir;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .count(count),
        .dir(dir)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            reset = 1;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset behavior", test_num);
            reset_dut();


            #1;



            check_outputs(32'd0, dir);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Forward movement (4 steps)", test_num);
            reset_dut();
            a = 1; b = 0; @(posedge clk); #1;
            a = 1; b = 1; @(posedge clk); #1;
            a = 0; b = 1; @(posedge clk); #1;
            a = 0; b = 0; @(posedge clk); #1;
            #1;

            check_outputs(32'd4, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Backward movement (4 steps)", test_num);
            reset_dut();
            a = 0; b = 1; @(posedge clk); #1;
            a = 1; b = 1; @(posedge clk); #1;
            a = 1; b = 0; @(posedge clk); #1;
            a = 0; b = 0; @(posedge clk); #1;
            #1;

            check_outputs(32'hFFFFFFFC, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Mixed direction (2 Fwd, 1 Bwd)", test_num);
            reset_dut();

            a = 1; b = 0; @(posedge clk); #1;
            a = 1; b = 1; @(posedge clk); #1;

            a = 1; b = 0; @(posedge clk); #1;
            #1;

            check_outputs(32'd1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Oscillation/Dithering", test_num);
            reset_dut();
            a = 1; b = 0; @(posedge clk); #1;
            a = 0; b = 0; @(posedge clk); #1;
            a = 1; b = 0; @(posedge clk); #1;
            #1;

            check_outputs(32'd1, 1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Multiple cycles (8 steps forward)", test_num);
            reset_dut();
            for(i=0; i<2; i=i+1) begin
                a = 1; b = 0; @(posedge clk); #1;
                a = 1; b = 1; @(posedge clk); #1;
                a = 0; b = 1; @(posedge clk); #1;
                a = 0; b = 0; @(posedge clk); #1;
            end
            #1;

            check_outputs(32'd8, 1'b1);
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
        input [31:0] expected_count;
        input expected_dir;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_dir === (expected_dir ^ dir ^ expected_dir)) begin
                $display("PASS");
                $display("  Outputs: count=%h, dir=%b",
                         count, dir);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, dir=%b",
                         expected_count, expected_dir);
                $display("  Got:      count=%h, dir=%b",
                         count, dir);
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
        $dumpvars(0,a, b, clk, reset, count, dir);
    end

endmodule
