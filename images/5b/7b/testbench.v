`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] oe;
    reg [15:0] reg_val;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .oe(oe),
        .reg_val(reg_val)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            oe = 16'h0000;
            reg_val = 16'hAAAA;
            #1;

            check_outputs(get_expected(oe, reg_val));
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            oe = 16'hFFFF;
            reg_val = 16'h5555;
            #1;

            check_outputs(get_expected(oe, reg_val));
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            oe = 16'h00FF;
            reg_val = 16'h1234;
            #1;

            check_outputs(get_expected(oe, reg_val));
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            oe = 16'hAAAA;
            reg_val = 16'hFFFF;
            #1;

            check_outputs(get_expected(oe, reg_val));
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            oe = 16'h5555;
            reg_val = 16'h0000;
            #1;

            check_outputs(get_expected(oe, reg_val));
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            oe = 16'h0001;
            reg_val = 16'hFFFF;
            #1;

            check_outputs(get_expected(oe, reg_val));
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            oe = 16'h8000;
            reg_val = 16'hFFFF;
            #1;

            check_outputs(get_expected(oe, reg_val));
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
        begin
            #1; // Small delay for combinational logic to settle
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
