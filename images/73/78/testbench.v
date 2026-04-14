`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] F;
    reg [17:0] param_open_loop_bias;
    reg [17:0] param_open_loop_scalar;
    wire [17:0] V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .F(F),
        .param_open_loop_bias(param_open_loop_bias),
        .param_open_loop_scalar(param_open_loop_scalar),
        .V(V)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Zeros", test_num);
            F = 32'h00000000;
            param_open_loop_bias = 18'h00000;
            param_open_loop_scalar = 18'h00000;
            #1;

            check_outputs(18'h00000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Positive Scaling (F=2.0, S=0.5, B=1.0)", test_num);





            F = 32'h00800000;
            param_open_loop_scalar = 18'h08000;
            param_open_loop_bias = 18'h04000;
            #1;

            check_outputs(18'h02000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Negative Frequency (F=-4.0, S=0.25, B=0)", test_num);






            F = 32'hFF000000;
            param_open_loop_scalar = 18'h04000;
            param_open_loop_bias = 18'h00000;
            #1;

            check_outputs(18'h01000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Negative Bias (F=1.0, S=1.0, B=-2.0)", test_num);





            F = 32'h00400000;
            param_open_loop_scalar = 18'h10000;
            param_open_loop_bias = 18'h38000;
            #1;

            check_outputs(18'h3F000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Negative Scalar (F=2.0, S=-0.5, B=0)", test_num);





            F = 32'h00800000;
            param_open_loop_scalar = 18'h38000;
            param_open_loop_bias = 18'h00000;
            #1;

            check_outputs(18'h3F000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Fractional Scaling (F=1.5, S=1.5, B=0.5)", test_num);





            F = 32'h00600000;
            param_open_loop_scalar = 18'h18000;
            param_open_loop_bias = 18'h02000;
            #1;

            check_outputs(18'h02C00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Negative Result with Negative F (F=-2.0, S=0.5, B=-2.0)", test_num);





            F = 32'hFF800000;
            param_open_loop_scalar = 18'h08000;
            param_open_loop_bias = 18'h38000;
            #1;

            check_outputs(18'h3F000);
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
        input [17:0] expected_V;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_V === (expected_V ^ V ^ expected_V)) begin
                $display("PASS");
                $display("  Outputs: V=%h",
                         V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: V=%h",
                         expected_V);
                $display("  Got:      V=%h",
                         V);
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
