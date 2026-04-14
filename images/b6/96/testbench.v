`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] A;
    reg [2:0] B;
    reg clk;
    reg cm1;
    wire OV;
    wire [2:0] S;
    wire c2;
    wire c2final;
    wire [3:0] digit;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .cm1(cm1),
        .OV(OV),
        .S(S),
        .c2(c2),
        .c2final(c2final),
        .digit(digit)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            cm1 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            A = 3'b001; B = 3'b001; cm1 = 1'b0;
            @(posedge clk);
            #2;
            $display("Test Case 001: 1 + 1 + 0");
            #1;

            check_outputs(1'b0, 3'b010, 1'b0, 1'b0, 4'b0010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            A = 3'b001; B = 3'b010; cm1 = 1'b1;
            @(posedge clk);
            #2;
            $display("Test Case 002: 1 + 2 + 1 (Carry-in)");
            #1;

            check_outputs(1'b1, 3'b100, 1'b0, 1'b0, 4'b0100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            A = 3'b111; B = 3'b001; cm1 = 1'b0;
            @(posedge clk);
            #2;
            $display("Test Case 003: 7 + 1 + 0 (Carry-out)");
            #1;

            check_outputs(1'b0, 3'b000, 1'b1, 1'b1, 4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            A = 3'b100; B = 3'b100; cm1 = 1'b0;
            @(posedge clk);
            #2;
            $display("Test Case 004: 4 + 4 + 0 (Negative Overflow)");
            #1;

            check_outputs(1'b1, 3'b000, 1'b1, 1'b1, 4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            A = 3'b111; B = 3'b111; cm1 = 1'b1;
            @(posedge clk);
            #2;
            $display("Test Case 005: 7 + 7 + 1 (Max values)");
            #1;

            check_outputs(1'b0, 3'b111, 1'b1, 1'b1, 4'b1111);
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
        input expected_OV;
        input [2:0] expected_S;
        input expected_c2;
        input expected_c2final;
        input [3:0] expected_digit;
        begin
            if (expected_OV === (expected_OV ^ OV ^ expected_OV) &&
                expected_S === (expected_S ^ S ^ expected_S) &&
                expected_c2 === (expected_c2 ^ c2 ^ expected_c2) &&
                expected_c2final === (expected_c2final ^ c2final ^ expected_c2final) &&
                expected_digit === (expected_digit ^ digit ^ expected_digit)) begin
                $display("PASS");
                $display("  Outputs: OV=%b, S=%h, c2=%b, c2final=%b, digit=%h",
                         OV, S, c2, c2final, digit);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OV=%b, S=%h, c2=%b, c2final=%b, digit=%h",
                         expected_OV, expected_S, expected_c2, expected_c2final, expected_digit);
                $display("  Got:      OV=%b, S=%h, c2=%b, c2final=%b, digit=%h",
                         OV, S, c2, c2final, digit);
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
        $dumpvars(0,A, B, clk, cm1, OV, S, c2, c2final, digit);
    end

endmodule
