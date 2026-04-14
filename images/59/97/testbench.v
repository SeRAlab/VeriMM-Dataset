`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] input_a;
    reg [31:0] input_b;
    wire [31:0] out;
    wire zeroflag_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_a(input_a),
        .input_b(input_b),
        .out(out),
        .zeroflag_out(zeroflag_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Simple Addition", test_num);
            input_a = 32'h00000005;
            input_b = 32'h0000000A;
            #1;

            check_outputs(32'h0000000F, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Zero Inputs", test_num);
            input_a = 32'h00000000;
            input_b = 32'h00000000;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Wrap-around to Zero", test_num);
            input_a = 32'hFFFFFFFF;
            input_b = 32'h00000001;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Max Values", test_num);
            input_a = 32'hFFFFFFFF;
            input_b = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFE, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Large Numbers", test_num);
            input_a = 32'h12345678;
            input_b = 32'h87654321;
            #1;

            check_outputs(32'h99999999, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Bit Patterns", test_num);
            input_a = 32'hAAAAAAAA;
            input_b = 32'h55555555;
            #1;

            check_outputs(32'hFFFFFFFF, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: MSB Overflow to Zero", test_num);
            input_a = 32'h80000000;
            input_b = 32'h80000000;
            #1;

            check_outputs(32'h00000000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: One Zero Input", test_num);
            input_a = 32'hDEADBEEF;
            input_b = 32'h00000000;
            #1;

            check_outputs(32'hDEADBEEF, 1'b0);
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
        input [31:0] expected_out;
        input expected_zeroflag_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_zeroflag_out === (expected_zeroflag_out ^ zeroflag_out ^ expected_zeroflag_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h, zeroflag_out=%b",
                         out, zeroflag_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, zeroflag_out=%b",
                         expected_out, expected_zeroflag_out);
                $display("  Got:      out=%h, zeroflag_out=%b",
                         out, zeroflag_out);
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
