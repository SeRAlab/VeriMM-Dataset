`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] in;
    reg reset;
    wire [31:0] max;
    wire [31:0] min;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .max(max),
        .min(min)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            in = 0;
            @(posedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Positive numbers sequence", test_num);
            reset_dut();
            @(posedge clk); in = 32'd10;
            @(posedge clk); in = 32'd20;
            @(posedge clk); in = 32'd5;
            @(posedge clk); in = 32'd15;
            @(posedge clk);
            #1;

            check_outputs(32'd20, 32'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative numbers sequence", test_num);
            reset_dut();
            @(posedge clk); in = -32'd10;
            @(posedge clk); in = -32'd20;
            @(posedge clk); in = -32'd5;
            @(posedge clk); in = -32'd15;
            @(posedge clk);
            #1;

            check_outputs(-32'd5, -32'd20);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed positive and negative numbers", test_num);
            reset_dut();
            @(posedge clk); in = 32'd100;
            @(posedge clk); in = -32'd100;
            @(posedge clk); in = 32'd0;
            @(posedge clk); in = 32'd50;
            @(posedge clk); in = -32'd50;
            @(posedge clk);
            #1;

            check_outputs(32'd100, -32'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Extreme signed boundaries", test_num);
            reset_dut();
            @(posedge clk); in = 32'h7FFFFFFF;
            @(posedge clk); in = 32'h80000000;
            @(posedge clk); in = 32'd0;
            @(posedge clk);
            #1;

            check_outputs(32'h7FFFFFFF, 32'h80000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identical values", test_num);
            reset_dut();
            @(posedge clk); in = 32'd42;
            @(posedge clk); in = 32'd42;
            @(posedge clk); in = 32'd42;
            @(posedge clk);
            #1;

            check_outputs(32'd42, 32'd42);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Increasing sequence", test_num);
            reset_dut();
            @(posedge clk); in = 32'd1;
            @(posedge clk); in = 32'd2;
            @(posedge clk); in = 32'd3;
            @(posedge clk); in = 32'd4;
            @(posedge clk); in = 32'd5;
            @(posedge clk);
            #1;

            check_outputs(32'd5, 32'd1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Decreasing sequence", test_num);
            reset_dut();
            @(posedge clk); in = 32'd10;
            @(posedge clk); in = 32'd8;
            @(posedge clk); in = 32'd6;
            @(posedge clk); in = 32'd4;
            @(posedge clk); in = 32'd2;
            @(posedge clk);
            #1;

            check_outputs(32'd10, 32'd2);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset initialization state", test_num);

            @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;


            #1;



            check_outputs(32'h80000000, 32'h7FFFFFFF);
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
        input [31:0] expected_max;
        input [31:0] expected_min;
        begin
            if (expected_max === (expected_max ^ max ^ expected_max) &&
                expected_min === (expected_min ^ min ^ expected_min)) begin
                $display("PASS");
                $display("  Outputs: max=%h, min=%h",
                         max, min);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max=%h, min=%h",
                         expected_max, expected_min);
                $display("  Got:      max=%h, min=%h",
                         max, min);
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
        $dumpvars(0,clk, in, reset, max, min);
    end

endmodule
