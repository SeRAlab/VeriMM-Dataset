`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg S;
    reg a;
    reg areset;
    reg b;
    reg [3:0] binary;
    wire [3:0] abs_val;
    wire [3:0] final_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S(S),
        .a(a),
        .areset(areset),
        .b(b),
        .binary(binary),
        .abs_val(abs_val),
        .final_output(final_output)
    );
    task testcase001;

        begin
            areset = 1; #5; areset = 0;
            a = 0; b = 0; S = 0;
            binary = 4'b0101;
            #1;

            check_outputs(4'd5, 4'd5);
        end
        endtask

    task testcase002;

        begin
            areset = 1; #5; areset = 0;
            binary = 4'b1011;
            #1;

            check_outputs(4'd5, 4'd5);
        end
        endtask

    task testcase003;

        begin
            areset = 1; #5; areset = 0;
            binary = 4'b0000;
            #1;

            check_outputs(4'd0, 4'd0);
        end
        endtask

    task testcase004;

        begin
            areset = 1; #5; areset = 0;
            binary = 4'b1000;
            #1;

            check_outputs(4'b1000, 4'b1000);
        end
        endtask

    task testcase005;

        begin
            areset = 1;
            binary = 4'b0111;
            #1;

            check_outputs(4'd7, 4'd0);
        end
        endtask

    task testcase006;

        begin
            areset = 1;
            binary = 4'b1110;
            #1;

            check_outputs(4'd2, 4'd0);
        end
        endtask

    task testcase007;

        begin
            areset = 1; #5; areset = 0;
            a = 1; b = 0; S = 0;
            binary = 4'b0011;
            #1;

            check_outputs(4'd3, 4'd3);
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
        input [3:0] expected_abs_val;
        input [3:0] expected_final_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_abs_val === (expected_abs_val ^ abs_val ^ expected_abs_val) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output)) begin
                $display("PASS");
                $display("  Outputs: abs_val=%h, final_output=%h",
                         abs_val, final_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: abs_val=%h, final_output=%h",
                         expected_abs_val, expected_final_output);
                $display("  Got:      abs_val=%h, final_output=%h",
                         abs_val, final_output);
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
