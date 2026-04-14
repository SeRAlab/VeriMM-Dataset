`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] input_a;
    wire [5:0] a_e;
    wire [15:0] a_m;
    wire a_s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_a(input_a),
        .a_e(a_e),
        .a_m(a_m),
        .a_s(a_s)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1.0 (0x3C00)", test_num);
            input_a = 16'h3C00;

            #1;


            check_outputs(6'h00, 16'h8000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input -1.0 (0xBC00)", test_num);
            input_a = 16'hBC00;

            #1;


            check_outputs(6'h00, 16'h8000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Zero (0x0000)", test_num);
            input_a = 16'h0000;

            #1;


            check_outputs(6'h31, 16'h8000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Max Exp, 0 Frac (0x7C00)", test_num);
            input_a = 16'h7C00;

            #1;


            check_outputs(6'h10, 16'h8000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1.5 (0x3E00)", test_num);
            input_a = 16'h3E00;

            #1;


            check_outputs(6'h00, 16'hC000, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 0.5 (0x3800)", test_num);
            input_a = 16'h3800;

            #1;


            check_outputs(6'h3F, 16'h8000, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Max Frac (0x3BFF)", test_num);
            input_a = 16'h3BFF;

            #1;


            check_outputs(6'h3F, 16'hFFF0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 2.0 (0x4000)", test_num);
            input_a = 16'h4000;

            #1;


            check_outputs(6'h01, 16'h8000, 1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input Pattern 0x3555", test_num);
            input_a = 16'h3555;

            #1;


            check_outputs(6'h3E, 16'hAAA0, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input All Ones (0xFFFF)", test_num);
            input_a = 16'hFFFF;

            #1;


            check_outputs(6'h10, 16'hFFF0, 1'b1);
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
        input [5:0] expected_a_e;
        input [15:0] expected_a_m;
        input expected_a_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_e === (expected_a_e ^ a_e ^ expected_a_e) &&
                expected_a_m === (expected_a_m ^ a_m ^ expected_a_m) &&
                expected_a_s === (expected_a_s ^ a_s ^ expected_a_s)) begin
                $display("PASS");
                $display("  Outputs: a_e=%h, a_m=%h, a_s=%b",
                         a_e, a_m, a_s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_e=%h, a_m=%h, a_s=%b",
                         expected_a_e, expected_a_m, expected_a_s);
                $display("  Got:      a_e=%h, a_m=%h, a_s=%b",
                         a_e, a_m, a_s);
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
