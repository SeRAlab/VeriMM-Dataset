`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] data;
    wire [31:0] out_lower;
    wire [31:0] out_upper;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .out_lower(out_lower),
        .out_upper(out_upper)
    );
    task testcase001;

        begin
            $display("\nTestcase 001: All zeros");
            data = 64'h00000000_00000000;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: All ones");
            data = 64'hFFFFFFFF_FFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF, 32'hFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Upper half ones, lower half zeros");
            data = 64'hFFFFFFFF_00000000;
            #1;

            check_outputs(32'h00000000, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Lower half ones, upper half zeros");
            data = 64'h00000000_FFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Hex pattern sequence");
            data = 64'h12345678_9ABCDEF0;
            #1;

            check_outputs(32'h9ABCDEF0, 32'h12345678);
        end
        endtask

    task testcase006;

        begin
            $display("\nTestcase 006: Alternating bits (A/5)");
            data = 64'hAAAAAAAA_55555555;
            #1;

            check_outputs(32'h55555555, 32'hAAAAAAAA);
        end
        endtask

    task testcase007;

        begin
            $display("\nTestcase 007: Known constant values");
            data = 64'hDEADBEEF_CAFEBABE;
            #1;

            check_outputs(32'hCAFEBABE, 32'hDEADBEEF);
        end
        endtask

    task testcase008;

        begin
            $display("\nTestcase 008: Boundary bits check");
            data = 64'h80000000_00000001;
            #1;

            check_outputs(32'h00000001, 32'h80000000);
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
        input [31:0] expected_out_lower;
        input [31:0] expected_out_upper;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_lower === (expected_out_lower ^ out_lower ^ expected_out_lower) &&
                expected_out_upper === (expected_out_upper ^ out_upper ^ expected_out_upper)) begin
                $display("PASS");
                $display("  Outputs: out_lower=%h, out_upper=%h",
                         out_lower, out_upper);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_lower=%h, out_upper=%h",
                         expected_out_lower, expected_out_upper);
                $display("  Got:      out_lower=%h, out_upper=%h",
                         out_lower, out_upper);
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
