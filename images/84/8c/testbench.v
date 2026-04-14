`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg reset;
    reg [2:0] state;
    wire [7:0] display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .reset(reset),
        .state(state),
        .display(display)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Reset Active (State 000)", test_num);
        reset = 1;
        state = 3'b000;
        #10;
        #1;

        check_outputs(PATTERN_DEFAULT);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Reset Active (State 111)", test_num);
        reset = 1;
        state = 3'b111;
        #10;
        #1;

        check_outputs(PATTERN_DEFAULT);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: State 000 (Reset Deasserted)", test_num);
        reset = 1; #5;
        reset = 0;
        state = 3'b000;
        #10;
        #1;

        check_outputs(PATTERN_0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: State 001", test_num);
        reset = 1; #5;
        reset = 0;
        state = 3'b001;
        #10;
        #1;

        check_outputs(PATTERN_1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: State 010", test_num);
        reset = 1; #5;
        reset = 0;
        state = 3'b010;
        #10;
        #1;

        check_outputs(PATTERN_2);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: State 011", test_num);
        reset = 1; #5;
        reset = 0;
        state = 3'b011;
        #10;
        #1;

        check_outputs(PATTERN_3);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: State 100", test_num);
        reset = 1; #5;
        reset = 0;
        state = 3'b100;
        #10;
        #1;

        check_outputs(PATTERN_4);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: State 101", test_num);
        reset = 1; #5;
        reset = 0;
        state = 3'b101;
        #10;
        #1;

        check_outputs(PATTERN_5);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: State 110", test_num);
        reset = 1; #5;
        reset = 0;
        state = 3'b110;
        #10;
        #1;

        check_outputs(PATTERN_6);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: State 111", test_num);
        reset = 1; #5;
        reset = 0;
        state = 3'b111;
        #10;
        #1;

        check_outputs(PATTERN_7);
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
        input [7:0] expected_display;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_display === (expected_display ^ display ^ expected_display)) begin
                $display("PASS");
                $display("  Outputs: display=%h",
                         display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: display=%h",
                         expected_display);
                $display("  Got:      display=%h",
                         display);
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
