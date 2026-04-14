`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [1:0] B;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Y(Y)
    );
    task testcase001;

    begin
        A = 4'b1010;
        B = 2'b00;
        #10;
        $display("Testcase 001: A=%b, B=%b (No shift)", A, B);
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase002;

    begin
        A = 4'b1011;
        B = 2'b01;
        #10;
        $display("Testcase 002: A=%b, B=%b (1-bit Left Shift)", A, B);
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        A = 4'b1101;
        B = 2'b10;
        #10;
        $display("Testcase 003: A=%b, B=%b (1-bit Right Shift)", A, B);
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase004;

    begin
        A = 4'b1111;
        B = 2'b11;
        #10;
        $display("Testcase 004: A=%b, B=%b (2-bit Right Shift)", A, B);
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase005;

    begin
        A = 4'b1000;
        B = 2'b01;
        #10;
        $display("Testcase 005: A=%b, B=%b (1-bit Left Shift)", A, B);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        A = 4'b0011;
        B = 2'b11;
        #10;
        $display("Testcase 006: A=%b, B=%b (2-bit Right Shift)", A, B);
        #1;

        check_outputs(4'b0000);
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
        input [3:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
