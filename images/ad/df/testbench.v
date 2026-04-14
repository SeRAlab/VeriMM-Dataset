`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    reg [3:0] D;
    reg [1:0] S;
    reg [3:0] binary_in;
    reg clk;
    wire EN1;
    wire EN2;
    wire EN3;
    wire [6:0] seven_segment_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .S(S),
        .binary_in(binary_in),
        .clk(clk),
        .EN1(EN1),
        .EN2(EN2),
        .EN3(EN3),
        .seven_segment_out(seven_segment_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        A = 0; B = 0; C = 0; D = 0; S = 0; binary_in = 0;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase 001: Priority Selection (A over others)");
        A = 4'd5; B = 4'd3; C = 4'd2; D = 4'd1; S = 2'b01;

        wait(EN1 == 1);
        #1;
        #1;

        check_outputs(1, 0, 0, SEG_5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase 002: Priority Selection (B over C,D)");
        A = 4'd0; B = 4'd9; C = 4'd2; D = 4'd1; S = 2'b01;
        wait(EN1 == 1);
        #1;
        #1;

        check_outputs(1, 0, 0, SEG_9);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase 003: Binary to BCD (Input 12, Units digit)");
        binary_in = 4'd12; S = 2'b00;

        wait(EN2 == 1);
        #1;
        #1;

        check_outputs(0, 1, 0, SEG_2);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase 004: Binary to BCD (Input 12, Tens digit)");
        binary_in = 4'd12; S = 2'b00;

        wait(EN3 == 1);
        #1;
        #1;

        check_outputs(0, 0, 1, SEG_1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase 005: Cycling Enable Signals");
        A = 4'd7; S = 2'b01;
        wait(EN1 == 1);
        @(posedge clk); #1;
        if (EN2 == 1) begin
            #1;

            check_outputs(0, 1, 0, SEG_7);
        end else begin
            $display("State transition to EN2 failed");
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
        input expected_EN1;
        input expected_EN2;
        input expected_EN3;
        input [6:0] expected_seven_segment_out;
        begin
            if (expected_EN1 === (expected_EN1 ^ EN1 ^ expected_EN1) &&
                expected_EN2 === (expected_EN2 ^ EN2 ^ expected_EN2) &&
                expected_EN3 === (expected_EN3 ^ EN3 ^ expected_EN3) &&
                expected_seven_segment_out === (expected_seven_segment_out ^ seven_segment_out ^ expected_seven_segment_out)) begin
                $display("PASS");
                $display("  Outputs: EN1=%b, EN2=%b, EN3=%b, seven_segment_out=%h",
                         EN1, EN2, EN3, seven_segment_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EN1=%b, EN2=%b, EN3=%b, seven_segment_out=%h",
                         expected_EN1, expected_EN2, expected_EN3, expected_seven_segment_out);
                $display("  Got:      EN1=%b, EN2=%b, EN3=%b, seven_segment_out=%h",
                         EN1, EN2, EN3, seven_segment_out);
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
        $dumpvars(0,A, B, C, D, S, binary_in, clk, EN1, EN2, EN3, seven_segment_out);
    end

endmodule
