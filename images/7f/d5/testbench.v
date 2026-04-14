`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] immediate;
    reg signed_ext;
    wire [31:0] ext;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .immediate(immediate),
        .signed_ext(signed_ext),
        .ext(ext)
    );
    task testcase001;

        begin
            $display("Testcase 001: Zero extension with MSB 0");
            immediate = 16'h1234;
            signed_ext = 1'b0;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Zero extension with MSB 1");
            immediate = 16'hABCD;
            signed_ext = 1'b0;
            #1;

            check_outputs(32'h0000ABCD);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Signed extension with MSB 0 (positive value)");
            immediate = 16'h7FFF;
            signed_ext = 1'b1;
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Signed extension with MSB 1 (negative value)");
            immediate = 16'h8000;
            signed_ext = 1'b1;
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: All zeros, signed_ext low");
            immediate = 16'h0000;
            signed_ext = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: All ones, signed_ext high");
            immediate = 16'hFFFF;
            signed_ext = 1'b1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: All ones, signed_ext low");
            immediate = 16'hFFFF;
            signed_ext = 1'b0;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Signed extension, small negative value");
            immediate = 16'hFFFE;
            signed_ext = 1'b1;
            #1;

            check_outputs(32'hFFFFFFFE);
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
        input [31:0] expected_ext;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ext === (expected_ext ^ ext ^ expected_ext)) begin
                $display("PASS");
                $display("  Outputs: ext=%h",
                         ext);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ext=%h",
                         expected_ext);
                $display("  Got:      ext=%h",
                         ext);
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
