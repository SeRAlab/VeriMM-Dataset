`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] reg_in_ex;
    reg [2:0] reg_out_ex;
    wire Sel2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .reg_in_ex(reg_in_ex),
        .reg_out_ex(reg_out_ex),
        .Sel2(Sel2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal zeros", test_num);
            reg_in_ex = 3'b000;
            reg_out_ex = 3'b000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal ones", test_num);
            reg_in_ex = 3'b111;
            reg_out_ex = 3'b111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Equal middle value", test_num);
            reg_in_ex = 3'b101;
            reg_out_ex = 3'b101;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Not equal (LSB difference)", test_num);
            reg_in_ex = 3'b000;
            reg_out_ex = 3'b001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Not equal (MSB difference)", test_num);
            reg_in_ex = 3'b011;
            reg_out_ex = 3'b111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Not equal (Opposites)", test_num);
            reg_in_ex = 3'b101;
            reg_out_ex = 3'b010;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Not equal (All vs Zero)", test_num);
            reg_in_ex = 3'b111;
            reg_out_ex = 3'b000;
            #1;

            check_outputs(1'b0);
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
        input expected_Sel2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Sel2 === (expected_Sel2 ^ Sel2 ^ expected_Sel2)) begin
                $display("PASS");
                $display("  Outputs: Sel2=%b",
                         Sel2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Sel2=%b",
                         expected_Sel2);
                $display("  Got:      Sel2=%b",
                         Sel2);
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
