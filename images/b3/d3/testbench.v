`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Add_Subt_i;
    reg eqXY_i;
    reg gtXY_i;
    reg sgn_X_i;
    reg sgn_Y_i;
    wire sgn_result_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Add_Subt_i(Add_Subt_i),
        .eqXY_i(eqXY_i),
        .gtXY_i(gtXY_i),
        .sgn_X_i(sgn_X_i),
        .sgn_Y_i(sgn_Y_i),
        .sgn_result_o(sgn_result_o)
    );
    task testcase001;

    begin
        test_num = 1;
        Add_Subt_i = 1'b0;
        sgn_X_i = 1'b0;
        sgn_Y_i = 1'b0;
        gtXY_i = 1'b1;
        eqXY_i = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        Add_Subt_i = 1'b0;
        sgn_X_i = 1'b1;
        sgn_Y_i = 1'b1;
        gtXY_i = 1'b1;
        eqXY_i = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        Add_Subt_i = 1'b0;
        sgn_X_i = 1'b0;
        sgn_Y_i = 1'b1;
        gtXY_i = 1'b1;
        eqXY_i = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        Add_Subt_i = 1'b0;
        sgn_X_i = 1'b0;
        sgn_Y_i = 1'b1;
        gtXY_i = 1'b0;
        eqXY_i = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        Add_Subt_i = 1'b0;
        sgn_X_i = 1'b0;
        sgn_Y_i = 1'b1;
        gtXY_i = 1'b0;
        eqXY_i = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        Add_Subt_i = 1'b0;
        sgn_X_i = 1'b1;
        sgn_Y_i = 1'b0;
        gtXY_i = 1'b1;
        eqXY_i = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        Add_Subt_i = 1'b0;
        sgn_X_i = 1'b1;
        sgn_Y_i = 1'b0;
        gtXY_i = 1'b0;
        eqXY_i = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        Add_Subt_i = 1'b1;
        sgn_X_i = 1'b0;
        sgn_Y_i = 1'b1;
        gtXY_i = 1'b1;
        eqXY_i = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        Add_Subt_i = 1'b1;
        sgn_X_i = 1'b1;
        sgn_Y_i = 1'b0;
        gtXY_i = 1'b1;
        eqXY_i = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        Add_Subt_i = 1'b1;
        sgn_X_i = 1'b0;
        sgn_Y_i = 1'b0;
        gtXY_i = 1'b1;
        eqXY_i = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        Add_Subt_i = 1'b1;
        sgn_X_i = 1'b0;
        sgn_Y_i = 1'b0;
        gtXY_i = 1'b0;
        eqXY_i = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        Add_Subt_i = 1'b1;
        sgn_X_i = 1'b0;
        sgn_Y_i = 1'b0;
        gtXY_i = 1'b0;
        eqXY_i = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        Add_Subt_i = 1'b1;
        sgn_X_i = 1'b1;
        sgn_Y_i = 1'b1;
        gtXY_i = 1'b1;
        eqXY_i = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        Add_Subt_i = 1'b1;
        sgn_X_i = 1'b1;
        sgn_Y_i = 1'b1;
        gtXY_i = 1'b0;
        eqXY_i = 1'b0;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        Add_Subt_i = 1'b1;
        sgn_X_i = 1'b1;
        sgn_Y_i = 1'b1;
        gtXY_i = 1'b0;
        eqXY_i = 1'b1;
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
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input expected_sgn_result_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sgn_result_o === (expected_sgn_result_o ^ sgn_result_o ^ expected_sgn_result_o)) begin
                $display("PASS");
                $display("  Outputs: sgn_result_o=%b",
                         sgn_result_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sgn_result_o=%b",
                         expected_sgn_result_o);
                $display("  Got:      sgn_result_o=%b",
                         sgn_result_o);
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
