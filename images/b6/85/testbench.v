`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ce;
    reg clk;
    reg clr;
    reg [15:0] in0;
    reg [15:0] in1;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ce(ce),
        .clk(clk),
        .clr(clr),
        .in0(in0),
        .in1(in1),
        .y(y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            ce = 0;
            in0 = 0;
            in1 = 0;
            @(posedge clk);
            #1;
            clr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Concatenation (ce=1)", test_num);
            in0 = 16'hABCD;
            in1 = 16'h1234;
            ce = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hABCD1234);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Clock Enable Low", test_num);
            in0 = 16'hFFFF;
            in1 = 16'hFFFF;
            ce = 0;
            clr = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Clear Signal Override", test_num);

            in0 = 16'hAAAA;
            in1 = 16'h5555;
            ce = 1;
            @(posedge clk);
            #2;

            clr = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Data Persistence", test_num);

            in0 = 16'h1111;
            in1 = 16'h2222;
            ce = 1;
            @(posedge clk);
            #2;

            ce = 0;
            in0 = 16'hEEEE;
            in1 = 16'hEEEE;
            @(posedge clk);
            #2;

            #1;


            check_outputs(32'h11112222);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Max Values", test_num);
            in0 = 16'hFFFF;
            in1 = 16'hFFFF;
            ce = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Multiple Consecutive Loads", test_num);
            ce = 1;
            in0 = 16'h1234; in1 = 16'h5678;
            @(posedge clk);
            #1;
            in0 = 16'h9ABC; in1 = 16'hDEF0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(32'h9ABCDEF0);
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
        input [31:0] expected_y;
        begin
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
        $dumpvars(0,ce, clk, clr, in0, in1, y);
    end

endmodule
