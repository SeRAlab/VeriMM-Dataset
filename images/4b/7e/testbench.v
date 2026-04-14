`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] in1;
    reg [10:0] in2;
    wire [11:0] Out_add;
    wire [11:0] Out_sub;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .Out_add(Out_add),
        .Out_sub(Out_sub)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive inputs (100, 50)", test_num);
            in1 = 11'd100;
            in2 = 11'd50;

            #1;


            check_outputs(12'd150, 12'd50);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero inputs (0, 0)", test_num);
            in1 = 11'd0;
            in2 = 11'd0;

            #1;


            check_outputs(12'd0, 12'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative inputs (-50, -25)", test_num);
            in1 = 11'h7CE;
            in2 = 11'h7E7;

            #1;


            check_outputs(12'hFB5, 12'hFE7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Positive inputs (1023, 1023)", test_num);
            in1 = 11'h3FF;
            in2 = 11'h3FF;

            #1;


            check_outputs(12'h7FE, 12'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum Negative inputs (-1024, -1024)", test_num);
            in1 = 11'h400;
            in2 = 11'h400;

            #1;


            check_outputs(12'h800, 12'h000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Max/Min 1 (-1024, 1023)", test_num);
            in1 = 11'h400;
            in2 = 11'h3FF;

            #1;


            check_outputs(12'hFFF, 12'h801);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Max/Min 2 (1023, -1024)", test_num);
            in1 = 11'h3FF;
            in2 = 11'h400;

            #1;


            check_outputs(12'hFFF, 12'h7FF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction leading to zero result (500, 500)", test_num);
            in1 = 11'd500;
            in2 = 11'd500;

            #1;


            check_outputs(12'd1000, 12'd0);
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
        input [11:0] expected_Out_add;
        input [11:0] expected_Out_sub;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out_add === (expected_Out_add ^ Out_add ^ expected_Out_add) &&
                expected_Out_sub === (expected_Out_sub ^ Out_sub ^ expected_Out_sub)) begin
                $display("PASS");
                $display("  Outputs: Out_add=%h, Out_sub=%h",
                         Out_add, Out_sub);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out_add=%h, Out_sub=%h",
                         expected_Out_add, expected_Out_sub);
                $display("  Got:      Out_add=%h, Out_sub=%h",
                         Out_add, Out_sub);
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
