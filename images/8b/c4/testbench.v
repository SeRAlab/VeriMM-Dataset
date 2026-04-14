`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [28:0] a;
    reg [27:0] b;
    reg ce;
    reg clk;
    wire [46:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ce(ce),
        .clk(clk),
        .p(p)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a <= 0;
            b <= 0;
            ce <= 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            a <= 29'd1000;
            b <= 28'd500;
            ce <= 1;
            repeat (3) @(posedge clk);
            ce <= 0;
            $display("Testcase %0d: Positive Mult (1000 * 500)", test_num);
            #1;

            check_outputs(calculate_expected(29'd1000, 28'd500));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            a <= 29'd12345;
            b <= -28'd6789;
            ce <= 1;
            repeat (3) @(posedge clk);
            ce <= 0;
            $display("Testcase %0d: Pos * Neg (12345 * -6789)", test_num);
            #1;

            check_outputs(calculate_expected(29'd12345, -28'd6789));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            a <= -29'd100;
            b <= -28'd200;
            ce <= 1;
            repeat (3) @(posedge clk);
            ce <= 0;
            $display("Testcase %0d: Neg * Neg (-100 * -200)", test_num);
            #1;

            check_outputs(calculate_expected(-29'd100, -28'd200));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            a <= 29'h1FFFFFFF;
            b <= 28'd0;
            ce <= 1;
            repeat (3) @(posedge clk);
            ce <= 0;
            $display("Testcase %0d: Mult by Zero", test_num);
            #1;

            check_outputs(47'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            a <= 29'sd1048576;
            b <= 29'sd1048576;
            ce <= 1;
            repeat (3) @(posedge clk);
            ce <= 0;
            $display("Testcase %0d: Large Product (2^40)", test_num);
            #1;

            check_outputs(calculate_expected(29'sd1048576, 28'sd1048576));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();

            a <= 29'h0FFFFFFF;
            b <= 28'h07FFFFFF;
            ce <= 1;
            repeat (3) @(posedge clk);
            ce <= 0;
            $display("Testcase %0d: Positive Saturation", test_num);
            #1;

            check_outputs(MAX_POS);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();

            a <= 29'h0FFFFFFF;
            b <= 28'h08000000;
            ce <= 1;
            repeat (3) @(posedge clk);
            ce <= 0;
            $display("Testcase %0d: Negative Saturation", test_num);
            #1;

            check_outputs(MIN_NEG);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();


            a <= 29'd50;
            b <= 28'd50;
            ce <= 1;
            repeat (3) @(posedge clk);


            ce <= 0;
            a <= 29'd999;
            b <= 28'd999;
            repeat (3) @(posedge clk);

            $display("Testcase %0d: Clock Enable Check (Data shouldn't change when ce=0)", test_num);

            #1;


            check_outputs(calculate_expected(29'd50, 28'd50));
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            a <= 29'h10000000;
            b <= 28'h08000000;
            ce <= 1;
            repeat (3) @(posedge clk);
            ce <= 0;
            $display("Testcase %0d: Min Negative Inputs (-2^28 * -2^27)", test_num);
            #1;

            check_outputs(MAX_POS);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();

            a <= 29'sd33554432;
            b <= 28'sd1048576;
            ce <= 1;
            repeat (3) @(posedge clk);
            ce <= 0;
            $display("Testcase %0d: Boundary check 2^45 (No saturation)", test_num);
            #1;

            check_outputs(47'h200000000000);
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
        input [46:0] expected_p;
        begin
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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
        $dumpvars(0,a, b, ce, clk, p);
    end

endmodule
