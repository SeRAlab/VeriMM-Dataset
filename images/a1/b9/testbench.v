`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] theInput;
    wire [31:0] resultOfShiftLeft2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .theInput(theInput),
        .resultOfShiftLeft2(resultOfShiftLeft2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input Zero", test_num);
            theInput = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input One", test_num);
            theInput = 32'h00000001;
            #1;

            check_outputs(32'h00000004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input All Ones", test_num);
            theInput = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MSB Shift Out (0xC0000000)", test_num);
            theInput = 32'hC0000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pattern 0xAAAAAAAA", test_num);
            theInput = 32'hAAAAAAAA;
            #1;

            check_outputs(32'hAAAAAAA8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pattern 0x55555555", test_num);
            theInput = 32'h55555555;
            #1;

            check_outputs(32'h55555554);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hex DEADBEEF", test_num);
            theInput = 32'hDEADBEEF;
            #1;

            check_outputs(32'h7AB6FBBC);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Lower boundary bits", test_num);
            theInput = 32'h00000003;
            #1;

            check_outputs(32'h0000000C);
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
        input [31:0] expected_resultOfShiftLeft2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_resultOfShiftLeft2 === (expected_resultOfShiftLeft2 ^ resultOfShiftLeft2 ^ expected_resultOfShiftLeft2)) begin
                $display("PASS");
                $display("  Outputs: resultOfShiftLeft2=%h",
                         resultOfShiftLeft2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: resultOfShiftLeft2=%h",
                         expected_resultOfShiftLeft2);
                $display("  Got:      resultOfShiftLeft2=%h",
                         resultOfShiftLeft2);
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
