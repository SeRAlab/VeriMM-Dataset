`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] signExtended;
    wire [31:0] ShiftResult;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .signExtended(signExtended),
        .ShiftResult(ShiftResult)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Zero input", test_num);
            signExtended = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Simple value 1", test_num);
            signExtended = 32'h00000001;
            #1;

            check_outputs(32'h00000004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: All ones input", test_num);
            signExtended = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: MSB shift out", test_num);
            signExtended = 32'hC0000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Random bit pattern", test_num);
            signExtended = 32'h12345678;
            #1;

            check_outputs(32'h48D159E0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Alternating bits pattern", test_num);
            signExtended = 32'hAAAAAAAA;
            #1;

            check_outputs(32'hAAAAAAA8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Boundary check", test_num);
            signExtended = 32'h3FFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFC);
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
        input [31:0] expected_ShiftResult;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ShiftResult === (expected_ShiftResult ^ ShiftResult ^ expected_ShiftResult)) begin
                $display("PASS");
                $display("  Outputs: ShiftResult=%h",
                         ShiftResult);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ShiftResult=%h",
                         expected_ShiftResult);
                $display("  Got:      ShiftResult=%h",
                         ShiftResult);
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
