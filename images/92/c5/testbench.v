`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] v1_reg_0;
    wire comp1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .v1_reg_0(v1_reg_0),
        .comp1(comp1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input v1_reg_0 = 0 (Expected comp1 = 0)", test_num);
            v1_reg_0 = 5'd0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input v1_reg_0 = 5 (Expected comp1 = 0)", test_num);
            v1_reg_0 = 5'd5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input v1_reg_0 = 8 (Expected comp1 = 0)", test_num);
            v1_reg_0 = 5'd8;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input v1_reg_0 = 9 (Expected comp1 = 1)", test_num);
            v1_reg_0 = 5'd9;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input v1_reg_0 = 10 (Expected comp1 = 1)", test_num);
            v1_reg_0 = 5'd10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input v1_reg_0 = 15 (Expected comp1 = 1)", test_num);
            v1_reg_0 = 5'd15;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input v1_reg_0 = 24 (Expected comp1 = 1)", test_num);
            v1_reg_0 = 5'd24;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input v1_reg_0 = 31 (Expected comp1 = 1)", test_num);
            v1_reg_0 = 5'd31;
            #1;

            check_outputs(1'b1);
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
        input expected_comp1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_comp1 === (expected_comp1 ^ comp1 ^ expected_comp1)) begin
                $display("PASS");
                $display("  Outputs: comp1=%b",
                         comp1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: comp1=%b",
                         expected_comp1);
                $display("  Got:      comp1=%b",
                         comp1);
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
