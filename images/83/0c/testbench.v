`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg in1_i;
    reg in2_i;
    reg in3_i;
    wire out_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1_i(in1_i),
        .in2_i(in2_i),
        .in3_i(in3_i),
        .out_o(out_o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All inputs LOW", test_num);
            in1_i = 1'b0; in2_i = 1'b0; in3_i = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Input 3 HIGH, others LOW", test_num);
            in1_i = 1'b0; in2_i = 1'b0; in3_i = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Input 2 HIGH, others LOW", test_num);
            in1_i = 1'b0; in2_i = 1'b1; in3_i = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Inputs 2 and 3 HIGH, Input 1 LOW", test_num);
            in1_i = 1'b0; in2_i = 1'b1; in3_i = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Input 1 HIGH, others LOW", test_num);
            in1_i = 1'b1; in2_i = 1'b0; in3_i = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Inputs 1 and 3 HIGH, Input 2 LOW", test_num);
            in1_i = 1'b1; in2_i = 1'b0; in3_i = 1'b1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Inputs 1 and 2 HIGH, Input 3 LOW", test_num);
            in1_i = 1'b1; in2_i = 1'b1; in3_i = 1'b0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: All inputs HIGH", test_num);
            in1_i = 1'b1; in2_i = 1'b1; in3_i = 1'b1;
            #1;

            check_outputs(1'b1);
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
        input expected_out_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_o === (expected_out_o ^ out_o ^ expected_out_o)) begin
                $display("PASS");
                $display("  Outputs: out_o=%b",
                         out_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_o=%b",
                         expected_out_o);
                $display("  Got:      out_o=%b",
                         out_o);
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
