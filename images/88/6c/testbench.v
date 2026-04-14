`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] UNEXTENDED;
    wire [31:0] EXTNDED_SHIFT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .UNEXTENDED(UNEXTENDED),
        .EXTNDED_SHIFT(EXTNDED_SHIFT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero input (8'h00)", test_num);
            UNEXTENDED = 8'h00;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small positive value (8'h01)", test_num);
            UNEXTENDED = 8'h01;
            #1;

            check_outputs(32'h00000004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum positive 8-bit value (8'h7F)", test_num);
            UNEXTENDED = 8'h7F;
            #1;

            check_outputs(32'h000001FC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum negative 8-bit value (8'h80)", test_num);
            UNEXTENDED = 8'h80;
            #1;

            check_outputs(32'hFFFFFE00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones / -1 (8'hFF)", test_num);
            UNEXTENDED = 8'hFF;
            #1;

            check_outputs(32'hFFFFFFFC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits positive (8'h55)", test_num);
            UNEXTENDED = 8'h55;
            #1;

            check_outputs(32'h00000154);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits negative (8'hAA)", test_num);
            UNEXTENDED = 8'hAA;
            #1;

            check_outputs(32'hFFFFFEA8);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary positive value (8'h23)", test_num);
            UNEXTENDED = 8'h23;
            #1;

            check_outputs(32'h0000008C);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary negative value (8'hC3)", test_num);
            UNEXTENDED = 8'hC3;
            #1;

            check_outputs(32'hFFFFFF0C);
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
        input [31:0] expected_EXTNDED_SHIFT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EXTNDED_SHIFT === (expected_EXTNDED_SHIFT ^ EXTNDED_SHIFT ^ expected_EXTNDED_SHIFT)) begin
                $display("PASS");
                $display("  Outputs: EXTNDED_SHIFT=%h",
                         EXTNDED_SHIFT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EXTNDED_SHIFT=%h",
                         expected_EXTNDED_SHIFT);
                $display("  Got:      EXTNDED_SHIFT=%h",
                         EXTNDED_SHIFT);
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
