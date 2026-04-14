`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] digit1;
    reg [3:0] digit2;
    reg [3:0] digit3;
    reg [3:0] digit4;
    reg [3:0] digit5;
    reg [3:0] digit6;
    reg [3:0] digit7;
    reg [3:0] digit8;
    reg [2:0] position_pointer;
    reg [2:0] refreshcounter;
    reg [2:0] state;
    wire [3:0] ONE_DIGIT;
    wire position_pointer_now;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .digit1(digit1),
        .digit2(digit2),
        .digit3(digit3),
        .digit4(digit4),
        .digit5(digit5),
        .digit6(digit6),
        .digit7(digit7),
        .digit8(digit8),
        .position_pointer(position_pointer),
        .refreshcounter(refreshcounter),
        .state(state),
        .ONE_DIGIT(ONE_DIGIT),
        .position_pointer_now(position_pointer_now)
    );
    task set_default_digits;

        begin
            digit1 = 4'h1; digit2 = 4'h2; digit3 = 4'h3; digit4 = 4'h4;
            digit5 = 4'h5; digit6 = 4'h6; digit7 = 4'h7; digit8 = 4'h8;
            state = 3'b000;
            position_pointer = 3'b000;
            refreshcounter = 3'b000;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            set_default_digits();
            refreshcounter = 3'd0;
            #10;
            $display("Test %0d: Select Digit 1 (refreshcounter=0)", test_num);
            #1;

            check_outputs(4'h1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            set_default_digits();
            refreshcounter = 3'd4;
            #10;
            $display("Test %0d: Select Digit 5 (refreshcounter=4)", test_num);
            #1;

            check_outputs(4'h5, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            set_default_digits();
            refreshcounter = 3'd7;
            #10;
            $display("Test %0d: Select Digit 8 (refreshcounter=7)", test_num);
            #1;

            check_outputs(4'h8, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            set_default_digits();
            state = 3'b001;
            position_pointer = 3'd2;
            refreshcounter = 3'd2;
            #10;
            $display("Test %0d: Pointer Match (refresh==pointer, state=1)", test_num);
            #1;

            check_outputs(4'h3, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            set_default_digits();
            state = 3'b001;
            position_pointer = 3'd2;
            refreshcounter = 3'd5;
            #10;
            $display("Test %0d: Pointer Mismatch (refresh!=pointer)", test_num);
            #1;

            check_outputs(4'h6, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            set_default_digits();
            state = 3'b000;
            position_pointer = 3'd2;
            refreshcounter = 3'd2;
            #10;
            $display("Test %0d: Pointer Match in State 0 (Expected low)", test_num);
            #1;

            check_outputs(4'h3, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            set_default_digits();
            refreshcounter = 3'd0;
            digit1 = 4'hA;
            #10;
            $display("Test %0d: Changing active digit data", test_num);
            #1;

            check_outputs(4'hA, 0);
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
        input [3:0] expected_ONE_DIGIT;
        input expected_position_pointer_now;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ONE_DIGIT === (expected_ONE_DIGIT ^ ONE_DIGIT ^ expected_ONE_DIGIT) &&
                expected_position_pointer_now === (expected_position_pointer_now ^ position_pointer_now ^ expected_position_pointer_now)) begin
                $display("PASS");
                $display("  Outputs: ONE_DIGIT=%h, position_pointer_now=%b",
                         ONE_DIGIT, position_pointer_now);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ONE_DIGIT=%h, position_pointer_now=%b",
                         expected_ONE_DIGIT, expected_position_pointer_now);
                $display("  Got:      ONE_DIGIT=%h, position_pointer_now=%b",
                         ONE_DIGIT, position_pointer_now);
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
