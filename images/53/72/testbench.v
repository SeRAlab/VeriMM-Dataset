`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] D;
    reg [1:0] S;
    reg shift_right;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .S(S),
        .shift_right(shift_right),
        .Q(Q)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        D = 4'b1011; S = 2'b00; shift_right = 1;
        #10;
        $display("Test %0d: Right Shift - Amount 0 (Input: %b)", test_num, D);
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        D = 4'b1011; S = 2'b01; shift_right = 1;
        #10;
        $display("Test %0d: Right Shift - Amount 1 (Input: %b)", test_num, D);
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        D = 4'b1011; S = 2'b10; shift_right = 1;
        #10;
        $display("Test %0d: Right Shift - Amount 2 (Input: %b)", test_num, D);
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        D = 4'b1011; S = 2'b11; shift_right = 1;
        #10;
        $display("Test %0d: Right Shift - Amount 3 (Input: %b)", test_num, D);
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        D = 4'b1101; S = 2'b00; shift_right = 0;
        #10;
        $display("Test %0d: Left Shift - Amount 0 (Input: %b)", test_num, D);
        #1;

        check_outputs(4'b1101);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        D = 4'b1101; S = 2'b01; shift_right = 0;
        #10;
        $display("Test %0d: Left Shift - Amount 1 (Input: %b)", test_num, D);
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        D = 4'b1101; S = 2'b10; shift_right = 0;
        #10;
        $display("Test %0d: Left Shift - Amount 2 (Input: %b)", test_num, D);
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        D = 4'b1101; S = 2'b11; shift_right = 0;
        #10;
        $display("Test %0d: Left Shift - Amount 3 (Input: %b)", test_num, D);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        D = 4'b0000; S = 2'b10; shift_right = 1;
        #10;
        $display("Test %0d: Right Shift All Zeros", test_num);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        D = 4'b1111; S = 2'b01; shift_right = 0;
        #10;
        $display("Test %0d: Left Shift All Ones", test_num);
        #1;

        check_outputs(4'b1110);
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
