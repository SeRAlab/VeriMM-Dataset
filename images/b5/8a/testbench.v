`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [1:0] B;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Q(Q)
    );
    task start_test;

        input [3:0] next_A;
        input [1:0] next_B;
        begin
            test_num = test_num + 1;
            A = next_A;
            B = next_B;
        end
        endtask

    task testcase001;

    begin
        start_test(4'b1010, 2'b00);
        $display("Test 001: No shift (B=00), Input A=1010");
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase002;

    begin
        start_test(4'b1011, 2'b01);
        $display("Test 002: Left Shift (B=01), Input A=1011");

        #1;


        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        start_test(4'b1011, 2'b10);
        $display("Test 003: Right Rotate (B=10), Input A=1011");

        #1;


        check_outputs(4'b1101);
    end
        endtask

    task testcase004;

    begin
        start_test(4'b1100, 2'b11);
        $display("Test 004: Priority Check (B=11), Right Rotate Priority, Input A=1100");

        #1;


        check_outputs(4'b0110);
    end
        endtask

    task testcase005;

    begin
        start_test(4'b1111, 2'b01);
        $display("Test 005: Left Shift (B=01), Input A=1111");

        #1;


        check_outputs(4'b1110);
    end
        endtask

    task testcase006;

    begin
        start_test(4'b0001, 2'b10);
        $display("Test 006: Right Rotate (B=10), Input A=0001");

        #1;


        check_outputs(4'b1000);
    end
        endtask

    task testcase007;

    begin
        start_test(4'b0110, 2'b00);
        $display("Test 007: No shift (B=00), Input A=0110");
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase008;

    begin
        start_test(4'b1000, 2'b01);
        $display("Test 008: Left Shift (B=01), Input A=1000");

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
        input [3:0] expected_Q;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
