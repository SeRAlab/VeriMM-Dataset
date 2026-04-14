`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A1_N;
    reg A2_N;
    reg B1;
    reg B2;
    reg VPWR;
    wire [1:0] Y;
    wire overflow_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A1_N(A1_N),
        .A2_N(A2_N),
        .B1(B1),
        .B2(B2),
        .VPWR(VPWR),
        .Y(Y),
        .overflow_flag(overflow_flag)
    );
    task testcase001;

    begin
        test_num = 1;
        VPWR = 1;
        A2_N = 0; A1_N = 0;
        B2 = 0; B1 = 0;
        $display("Test %0d: A=0, B=0", test_num);
        #1;

        check_outputs(2'b00, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        VPWR = 1;
        A2_N = 0; A1_N = 1;
        B2 = 0; B1 = 0;
        $display("Test %0d: A=1, B=0", test_num);
        #1;

        check_outputs(2'b01, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        VPWR = 1;
        A2_N = 0; A1_N = 1;
        B2 = 1; B1 = 0;
        $display("Test %0d: A=1, B=2", test_num);
        #1;

        check_outputs(2'b11, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        VPWR = 1;
        A2_N = 1; A1_N = 0;
        B2 = 1; B1 = 0;
        $display("Test %0d: A=2, B=2 (Expect Overflow)", test_num);
        #1;

        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        VPWR = 1;
        A2_N = 1; A1_N = 1;
        B2 = 0; B1 = 1;
        $display("Test %0d: A=3, B=1 (Expect Overflow)", test_num);
        #1;

        check_outputs(2'b00, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        VPWR = 1;
        A2_N = 1; A1_N = 1;
        B2 = 1; B1 = 0;
        $display("Test %0d: A=3, B=2 (Expect Overflow)", test_num);
        #1;

        check_outputs(2'b01, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        VPWR = 1;
        A2_N = 1; A1_N = 1;
        B2 = 1; B1 = 1;
        $display("Test %0d: A=3, B=3 (Expect Max Sum)", test_num);
        #1;

        check_outputs(2'b10, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        VPWR = 1;
        A2_N = 0; A1_N = 1;
        B2 = 0; B1 = 1;
        $display("Test %0d: A=1, B=1", test_num);
        #1;

        check_outputs(2'b10, 1'b0);
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
        input [1:0] expected_Y;
        input expected_overflow_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_overflow_flag === (expected_overflow_flag ^ overflow_flag ^ expected_overflow_flag)) begin
                $display("PASS");
                $display("  Outputs: Y=%h, overflow_flag=%b",
                         Y, overflow_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h, overflow_flag=%b",
                         expected_Y, expected_overflow_flag);
                $display("  Got:      Y=%h, overflow_flag=%b",
                         Y, overflow_flag);
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
