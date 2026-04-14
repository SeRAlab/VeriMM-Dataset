`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] pc;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .pc(pc),
        .result(result)
    );
    task testcase001;

        begin
            test_num = 1;
            pc = 32'h0000_0000;
            $display("Test %0d: Starting PC at zero", test_num);
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            pc = 32'h0000_0064;
            $display("Test %0d: Standard increment from 100", test_num);
            #1;

            check_outputs(32'h0000_0068);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            pc = 32'hFFFF_FFFC;
            $display("Test %0d: Increment leading to zero (32-bit wrap)", test_num);
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            pc = 32'hFFFF_FFFF;
            $display("Test %0d: Increment from maximum 32-bit value", test_num);
            #1;

            check_outputs(32'h0000_0003);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            pc = 32'h1234_5678;
            $display("Test %0d: Incrementing an arbitrary address", test_num);
            #1;

            check_outputs(32'h1234_567C);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            pc = 32'h0000_0FFC;
            $display("Test %0d: Checking carry propagation across nibbles", test_num);
            #1;

            check_outputs(32'h0000_1000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            pc = 32'hA5A5_A5A5;
            $display("Test %0d: Checking bit patterns", test_num);
            #1;

            check_outputs(32'hA5A5_A5A9);
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
