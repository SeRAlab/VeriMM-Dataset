`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] X;
    reg [15:0] Y;
    wire [15:0] subout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .X(X),
        .Y(Y),
        .subout(subout)
    );
    task testcase001;

        begin
            test_num = 1;
            X = 16'd100;
            Y = 16'd40;
            $display("Testcase %0d: Simple subtraction (100 - 40)", test_num);
            #1;

            check_outputs(16'd60);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            X = 16'd50;
            Y = 16'd50;
            $display("Testcase %0d: Result is zero (50 - 50)", test_num);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            X = 16'h0000;
            Y = 16'h0001;
            $display("Testcase %0d: Underflow/Wrap-around (0 - 1)", test_num);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            X = 16'hFFFF;
            Y = 16'h0001;
            $display("Testcase %0d: Subtract from Max Value (65535 - 1)", test_num);
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            X = 16'hFFFF;
            Y = 16'hFFFF;
            $display("Testcase %0d: Max - Max (65535 - 65535)", test_num);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            X = 16'h8000;
            Y = 16'h0001;
            $display("Testcase %0d: Boundary crossing (32768 - 1)", test_num);
            #1;

            check_outputs(16'h7FFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            X = 16'h1234;
            Y = 16'h0234;
            $display("Testcase %0d: Hex subtraction (1234 - 0234)", test_num);
            #1;

            check_outputs(16'h1000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            X = 16'hAAAA;
            Y = 16'h5555;
            $display("Testcase %0d: Alternating bit patterns", test_num);
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            X = 16'd0;
            Y = 16'h8000;
            $display("Testcase %0d: Large negative wrap (0 - 32768)", test_num);
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            X = 16'h1234;
            Y = 16'h5678;
            $display("Testcase %0d: Arbitrary subtraction with wrap (4660 - 22136)", test_num);
            #1;

            check_outputs(16'hBBBC);
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
        input [15:0] expected_subout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_subout === (expected_subout ^ subout ^ expected_subout)) begin
                $display("PASS");
                $display("  Outputs: subout=%h",
                         subout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: subout=%h",
                         expected_subout);
                $display("  Got:      subout=%h",
                         subout);
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

endmodule
