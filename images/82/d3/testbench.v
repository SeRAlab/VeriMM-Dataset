`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] PC;
    wire [31:0] PC_Adder_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .PC(PC),
        .PC_Adder_output(PC_Adder_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Starting with PC = 0", test_num);
            PC = 32'h00000000;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Incremental update from PC = 4", test_num);
            PC = 32'h00000004;
            #1;

            check_outputs(32'h00000005);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Upper byte carry check (0x0000FFFF)", test_num);
            PC = 32'h0000FFFF;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum value wrap-around check", test_num);
            PC = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary pattern check (0xAAAAAAAA)", test_num);
            PC = 32'hAAAAAAAA;
            #1;

            check_outputs(32'hAAAAAAAB);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random value check (0x12345678)", test_num);
            PC = 32'h12345678;
            #1;

            check_outputs(32'h12345679);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High bit boundary (0x7FFFFFFF)", test_num);
            PC = 32'h7FFFFFFF;
            #1;

            check_outputs(32'h80000000);
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
        input [31:0] expected_PC_Adder_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_PC_Adder_output === (expected_PC_Adder_output ^ PC_Adder_output ^ expected_PC_Adder_output)) begin
                $display("PASS");
                $display("  Outputs: PC_Adder_output=%h",
                         PC_Adder_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: PC_Adder_output=%h",
                         expected_PC_Adder_output);
                $display("  Got:      PC_Adder_output=%h",
                         PC_Adder_output);
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
