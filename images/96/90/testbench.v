`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] dat_i;
    reg sel_i;
    wire dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dat_i(dat_i),
        .sel_i(sel_i),
        .dat_o(dat_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select dat_i[0] (0), where dat_i is 2'b00", test_num);
            sel_i = 1'b0;
            dat_i = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select dat_i[0] (1), where dat_i is 2'b01", test_num);
            sel_i = 1'b0;
            dat_i = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select dat_i[0] (0), where dat_i is 2'b10", test_num);
            sel_i = 1'b0;
            dat_i = 2'b10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select dat_i[0] (1), where dat_i is 2'b11", test_num);
            sel_i = 1'b0;
            dat_i = 2'b11;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select dat_i[1] (0), where dat_i is 2'b00", test_num);
            sel_i = 1'b1;
            dat_i = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select dat_i[1] (0), where dat_i is 2'b01", test_num);
            sel_i = 1'b1;
            dat_i = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select dat_i[1] (1), where dat_i is 2'b10", test_num);
            sel_i = 1'b1;
            dat_i = 2'b10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select dat_i[1] (1), where dat_i is 2'b11", test_num);
            sel_i = 1'b1;
            dat_i = 2'b11;
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
        input expected_dat_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o)) begin
                $display("PASS");
                $display("  Outputs: dat_o=%b",
                         dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dat_o=%b",
                         expected_dat_o);
                $display("  Got:      dat_o=%b",
                         dat_o);
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
