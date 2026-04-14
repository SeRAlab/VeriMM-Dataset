`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in1;
    reg [15:0] in2;
    wire [15:0] subout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .subout(subout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Subtraction (50 - 20)", test_num);
            in1 = 16'd50;
            in2 = 16'd20;
            #1;

            check_outputs(16'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtracting Zero (1000 - 0)", test_num);
            in1 = 16'd1000;
            in2 = 16'd0;
            #1;

            check_outputs(16'd1000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Result is Zero (555 - 555)", test_num);
            in1 = 16'd555;
            in2 = 16'd555;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max value minus one (0xFFFF - 1)", test_num);
            in1 = 16'hFFFF;
            in2 = 16'h0001;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Underflow/Wraparound (0 - 1)", test_num);
            in1 = 16'h0000;
            in2 = 16'h0001;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large values (0x8000 - 0x7FFF)", test_num);
            in1 = 16'h8000;
            in2 = 16'h7FFF;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple bits borrowing (0x1000 - 0x0001)", test_num);
            in1 = 16'h1000;
            in2 = 16'h0001;
            #1;

            check_outputs(16'h0FFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtracting from Max (0xFFFF - 0x8000)", test_num);
            in1 = 16'hFFFF;
            in2 = 16'h8000;
            #1;

            check_outputs(16'h7FFF);
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
