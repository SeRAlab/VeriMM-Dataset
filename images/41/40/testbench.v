`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] v1_reg;
    wire comp1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .v1_reg(v1_reg),
        .comp1(comp1)
    );
    task testcase001;

        begin
            v1_reg = 5'd0;
            test_num = test_num + 1;
            $display("Testcase %0d: Input v1_reg = 0 (Minimum)", test_num);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            v1_reg = 5'd1;
            test_num = test_num + 1;
            $display("Testcase %0d: Input v1_reg = 1", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            v1_reg = 5'd15;
            test_num = test_num + 1;
            $display("Testcase %0d: Input v1_reg = 15 (Max value of lower 4 bits)", test_num);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            v1_reg = 5'd16;
            test_num = test_num + 1;
            $display("Testcase %0d: Input v1_reg = 16 (Boundary of the 5th bit)", test_num);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            v1_reg = 5'd17;
            test_num = test_num + 1;
            $display("Testcase %0d: Input v1_reg = 17", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            v1_reg = 5'd25;
            test_num = test_num + 1;
            $display("Testcase %0d: Input v1_reg = 25", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            v1_reg = 5'd30;
            test_num = test_num + 1;
            $display("Testcase %0d: Input v1_reg = 30", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            v1_reg = 5'd31;
            test_num = test_num + 1;
            $display("Testcase %0d: Input v1_reg = 31 (Maximum)", test_num);
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
