`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ack;
    reg d;
    reg done_counting;
    reg [9:0] state;
    wire B3_next;
    wire Count_next;
    wire S1_next;
    wire S_next;
    wire Wait_next;
    wire counting;
    wire done;
    wire shift_ena;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ack(ack),
        .d(d),
        .done_counting(done_counting),
        .state(state),
        .B3_next(B3_next),
        .Count_next(Count_next),
        .S1_next(S1_next),
        .S_next(S_next),
        .Wait_next(Wait_next),
        .counting(counting),
        .done(done),
        .shift_ena(shift_ena)
    );
    task reset_state;

        begin
            state = 10'b0000000001;
            d = 0;
            done_counting = 0;
            ack = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_state();
            d = 0;

            #1;


            check_outputs(0, 0, 0, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_state();
            d = 1;

            #1;


            check_outputs(0, 0, 1, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_state();
            state = 10'b0000000010;
            d = 0;

            #1;


            check_outputs(0, 0, 0, 1, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_state();
            state = 10'b0000000010;
            d = 1;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_state();
            state = 10'b0000000100;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_state();
            state = 10'b0000001000;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_state();
            state = 10'b0000010000;

            #1;


            check_outputs(1, 0, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_state();
            state = 10'b0000100000;

            #1;


            check_outputs(0, 1, 0, 0, 0, 0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_state();
            state = 10'b0001000000;
            done_counting = 0;

            #1;


            check_outputs(0, 1, 0, 0, 0, 1, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            reset_state();
            state = 10'b0001000000;
            done_counting = 1;

            #1;


            check_outputs(0, 0, 0, 0, 1, 1, 0, 0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            reset_state();
            state = 10'b0010000000;
            ack = 0;

            #1;


            check_outputs(0, 0, 0, 0, 1, 0, 1, 0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            reset_state();
            state = 10'b0010000000;
            ack = 1;

            #1;


            check_outputs(0, 0, 0, 1, 0, 0, 1, 0);
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
        input expected_B3_next;
        input expected_Count_next;
        input expected_S1_next;
        input expected_S_next;
        input expected_Wait_next;
        input expected_counting;
        input expected_done;
        input expected_shift_ena;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B3_next === (expected_B3_next ^ B3_next ^ expected_B3_next) &&
                expected_Count_next === (expected_Count_next ^ Count_next ^ expected_Count_next) &&
                expected_S1_next === (expected_S1_next ^ S1_next ^ expected_S1_next) &&
                expected_S_next === (expected_S_next ^ S_next ^ expected_S_next) &&
                expected_Wait_next === (expected_Wait_next ^ Wait_next ^ expected_Wait_next) &&
                expected_counting === (expected_counting ^ counting ^ expected_counting) &&
                expected_done === (expected_done ^ done ^ expected_done) &&
                expected_shift_ena === (expected_shift_ena ^ shift_ena ^ expected_shift_ena)) begin
                $display("PASS");
                $display("  Outputs: B3_next=%b, Count_next=%b, S1_next=%b, S_next=%b, Wait_next=%b, counting=%b, done=%b, shift_ena=%b",
                         B3_next, Count_next, S1_next, S_next, Wait_next, counting, done, shift_ena);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B3_next=%b, Count_next=%b, S1_next=%b, S_next=%b, Wait_next=%b, counting=%b, done=%b, shift_ena=%b",
                         expected_B3_next, expected_Count_next, expected_S1_next, expected_S_next, expected_Wait_next, expected_counting, expected_done, expected_shift_ena);
                $display("  Got:      B3_next=%b, Count_next=%b, S1_next=%b, S_next=%b, Wait_next=%b, counting=%b, done=%b, shift_ena=%b",
                         B3_next, Count_next, S1_next, S_next, Wait_next, counting, done, shift_ena);
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
