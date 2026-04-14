`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg fra_result;
    reg res;
    wire decre_en;
    wire incre_bit;
    wire incre_en;
    wire mux_4_en;
    wire mux_5_en;
    wire shift_left_en;
    wire shift_right_bits;
    wire shift_right_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .fra_result(fra_result),
        .res(res),
        .decre_en(decre_en),
        .incre_bit(incre_bit),
        .incre_en(incre_en),
        .mux_4_en(mux_4_en),
        .mux_5_en(mux_5_en),
        .shift_left_en(shift_left_en),
        .shift_right_bits(shift_right_bits),
        .shift_right_en(shift_right_en)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset Active (res=0), fra_result=0", test_num);
            res = 0;
            fra_result = 0;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Reset Active (res=0), fra_result=1", test_num);
            res = 0;
            fra_result = 1;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Reset Inactive (res=1), fra_result=1", test_num);
            res = 1;
            fra_result = 1;


            #1;



            check_outputs(0, 1, 1, 1, 1, 0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Reset Inactive (res=1), fra_result=0", test_num);
            res = 1;
            fra_result = 0;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Transition fra_result 1 -> 0 while res=1", test_num);
            res = 1;
            fra_result = 1;
            #5;
            fra_result = 0;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Transition res 1 -> 0 while fra_result=1", test_num);
            res = 1;
            fra_result = 1;
            #5;
            res = 0;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
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
        input expected_decre_en;
        input expected_incre_bit;
        input expected_incre_en;
        input expected_mux_4_en;
        input expected_mux_5_en;
        input expected_shift_left_en;
        input expected_shift_right_bits;
        input expected_shift_right_en;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decre_en === (expected_decre_en ^ decre_en ^ expected_decre_en) &&
                expected_incre_bit === (expected_incre_bit ^ incre_bit ^ expected_incre_bit) &&
                expected_incre_en === (expected_incre_en ^ incre_en ^ expected_incre_en) &&
                expected_mux_4_en === (expected_mux_4_en ^ mux_4_en ^ expected_mux_4_en) &&
                expected_mux_5_en === (expected_mux_5_en ^ mux_5_en ^ expected_mux_5_en) &&
                expected_shift_left_en === (expected_shift_left_en ^ shift_left_en ^ expected_shift_left_en) &&
                expected_shift_right_bits === (expected_shift_right_bits ^ shift_right_bits ^ expected_shift_right_bits) &&
                expected_shift_right_en === (expected_shift_right_en ^ shift_right_en ^ expected_shift_right_en)) begin
                $display("PASS");
                $display("  Outputs: decre_en=%b, incre_bit=%b, incre_en=%b, mux_4_en=%b, mux_5_en=%b, shift_left_en=%b, shift_right_bits=%b, shift_right_en=%b",
                         decre_en, incre_bit, incre_en, mux_4_en, mux_5_en, shift_left_en, shift_right_bits, shift_right_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decre_en=%b, incre_bit=%b, incre_en=%b, mux_4_en=%b, mux_5_en=%b, shift_left_en=%b, shift_right_bits=%b, shift_right_en=%b",
                         expected_decre_en, expected_incre_bit, expected_incre_en, expected_mux_4_en, expected_mux_5_en, expected_shift_left_en, expected_shift_right_bits, expected_shift_right_en);
                $display("  Got:      decre_en=%b, incre_bit=%b, incre_en=%b, mux_4_en=%b, mux_5_en=%b, shift_left_en=%b, shift_right_bits=%b, shift_right_en=%b",
                         decre_en, incre_bit, incre_en, mux_4_en, mux_5_en, shift_left_en, shift_right_bits, shift_right_en);
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
