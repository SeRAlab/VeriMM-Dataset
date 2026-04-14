`timescale 1ns/1ps

module divider_2bit_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] den;
    reg [1:0] num;
    wire [1:0] quot;
    wire [1:0] rem;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_2bit dut (
        .den(den),
        .num(num),
        .quot(quot),
        .rem(rem)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: num=0, den=0 (Div by zero)");
        num = 2'd0; den = 2'd0;
        #1;

        check_outputs(2'd0, 2'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: num=1, den=0 (Div by zero)");
        num = 2'd1; den = 2'd0;
        #1;

        check_outputs(2'd0, 2'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: num=2, den=0 (Div by zero)");
        num = 2'd2; den = 2'd0;
        #1;

        check_outputs(2'd0, 2'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: num=3, den=0 (Div by zero)");
        num = 2'd3; den = 2'd0;
        #1;

        check_outputs(2'd0, 2'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: num=0, den=1");
        num = 2'd0; den = 2'd1;
        #1;

        check_outputs(2'd0, 2'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: num=1, den=1");
        num = 2'd1; den = 2'd1;
        #1;

        check_outputs(2'd1, 2'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: num=2, den=1");
        num = 2'd2; den = 2'd1;
        #1;

        check_outputs(2'd2, 2'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: num=3, den=1");
        num = 2'd3; den = 2'd1;
        #1;

        check_outputs(2'd3, 2'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: num=0, den=2");
        num = 2'd0; den = 2'd2;
        #1;

        check_outputs(2'd0, 2'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: num=1, den=2");
        num = 2'd1; den = 2'd2;
        #1;

        check_outputs(2'd0, 2'd1);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test Case 011: num=2, den=2");
        num = 2'd2; den = 2'd2;
        #1;

        check_outputs(2'd1, 2'd0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test Case 012: num=3, den=2");
        num = 2'd3; den = 2'd2;
        #1;

        check_outputs(2'd1, 2'd1);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test Case 013: num=0, den=3");
        num = 2'd0; den = 2'd3;
        #1;

        check_outputs(2'd0, 2'd0);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Test Case 014: num=1, den=3");
        num = 2'd1; den = 2'd3;
        #1;

        check_outputs(2'd0, 2'd1);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Test Case 015: num=2, den=3");
        num = 2'd2; den = 2'd3;
        #1;

        check_outputs(2'd0, 2'd2);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Test Case 016: num=3, den=3");
        num = 2'd3; den = 2'd3;
        #1;

        check_outputs(2'd1, 2'd0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider_2bit Testbench");
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [1:0] expected_quot;
        input [1:0] expected_rem;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quot === (expected_quot ^ quot ^ expected_quot) &&
                expected_rem === (expected_rem ^ rem ^ expected_rem)) begin
                $display("PASS");
                $display("  Outputs: quot=%h, rem=%h",
                         quot, rem);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quot=%h, rem=%h",
                         expected_quot, expected_rem);
                $display("  Got:      quot=%h, rem=%h",
                         quot, rem);
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
