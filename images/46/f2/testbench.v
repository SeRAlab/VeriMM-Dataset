`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg sign_A;
    reg sign_B;
    reg sign_result;
    reg [3:0] value_A;
    reg [3:0] value_B;
    reg [3:0] value_result_tens;
    reg [3:0] value_result_units;
    wire [3:0] DIGIT;
    wire [8:0] DISPLAY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .sign_A(sign_A),
        .sign_B(sign_B),
        .sign_result(sign_result),
        .value_A(value_A),
        .value_B(value_B),
        .value_result_tens(value_result_tens),
        .value_result_units(value_result_units),
        .DIGIT(DIGIT),
        .DISPLAY(DISPLAY)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        sign_A = 0;
        sign_B = 0;
        sign_result = 0;
        value_A = 4'h0;
        value_B = 4'h0;
        value_result_tens = 4'h0;
        value_result_units = 4'h0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Display Value A (Positive 5)", test_num);
        reset_dut();
        value_A = 4'd5;
        sign_A = 0;



        wait(DIGIT == 4'b1110);
        #1;

        check_outputs(4'b1110, 9'h06D);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Display Value B (Positive 2)", test_num);
        reset_dut();
        value_B = 4'd2;
        sign_B = 0;

        wait(DIGIT == 4'b1101);
        #1;

        check_outputs(4'b1101, 9'h05B);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Display Result Tens (Value 1)", test_num);
        reset_dut();
        value_result_tens = 4'd1;

        wait(DIGIT == 4'b1011);
        #1;

        check_outputs(4'b1011, 9'h006);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Display Result Units (Value 9)", test_num);
        reset_dut();
        value_result_units = 4'd9;

        wait(DIGIT == 4'b0111);
        #1;

        check_outputs(4'b0111, 9'h06F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Display Value A (Negative 3)", test_num);
        reset_dut();
        value_A = 4'd3;
        sign_A = 1;

        wait(DIGIT == 4'b1110);

        #1;


        check_outputs(4'b1110, 9'h14F);
    end
        endtask

    task testcase006;

    reg [3:0] first_digit;
    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Multiplexing Cycle Verification", test_num);
        reset_dut();

        @(posedge clk);
        first_digit = DIGIT;
        @(posedge clk);
        if (DIGIT != first_digit) begin
            $display("  PASS: DIGIT transitioned from %b to %b", first_digit, DIGIT);
            pass_count = pass_count + 1;
        end else begin
            $display("  FAIL: DIGIT stuck at %b", first_digit);
            fail_count = fail_count + 1;
        end
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
        input [3:0] expected_DIGIT;
        input [8:0] expected_DISPLAY;
        begin
            if (expected_DIGIT === (expected_DIGIT ^ DIGIT ^ expected_DIGIT) &&
                expected_DISPLAY === (expected_DISPLAY ^ DISPLAY ^ expected_DISPLAY)) begin
                $display("PASS");
                $display("  Outputs: DIGIT=%h, DISPLAY=%h",
                         DIGIT, DISPLAY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DIGIT=%h, DISPLAY=%h",
                         expected_DIGIT, expected_DISPLAY);
                $display("  Got:      DIGIT=%h, DISPLAY=%h",
                         DIGIT, DISPLAY);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, sign_A, sign_B, sign_result, value_A, value_B, value_result_tens, value_result_units, DIGIT, DISPLAY);
    end

endmodule
