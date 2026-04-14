`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] num1;
    reg [3:0] num2;
    wire [3:0] larger;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .num1(num1),
        .num2(num2),
        .larger(larger)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: num1=5, num2=3 (num1 > num2)", test_num);
        num1 = 4'd5;
        num2 = 4'd3;
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: num1=2, num2=8 (num1 < num2)", test_num);
        num1 = 4'd2;
        num2 = 4'd8;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: num1=7, num2=7 (num1 == num2)", test_num);
        num1 = 4'd7;
        num2 = 4'd7;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: num1=0, num2=0 (Zero boundary)", test_num);
        num1 = 4'd0;
        num2 = 4'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: num1=15, num2=15 (Max boundary)", test_num);
        num1 = 4'd15;
        num2 = 4'd15;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: num1=0, num2=15 (Min vs Max)", test_num);
        num1 = 4'd0;
        num2 = 4'd15;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: num1=15, num2=0 (Max vs Min)", test_num);
        num1 = 4'd15;
        num2 = 4'd0;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: num1=10, num2=11", test_num);
        num1 = 4'd10;
        num2 = 4'd11;
        #1;

        check_outputs(4'd11);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: num1=12, num2=4", test_num);
        num1 = 4'd12;
        num2 = 4'd4;
        #1;

        check_outputs(4'd12);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: num1=1, num2=2", test_num);
        num1 = 4'd1;
        num2 = 4'd2;
        #1;

        check_outputs(4'd2);
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
        input [3:0] expected_larger;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_larger === (expected_larger ^ larger ^ expected_larger)) begin
                $display("PASS");
                $display("  Outputs: larger=%h",
                         larger);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: larger=%h",
                         expected_larger);
                $display("  Got:      larger=%h",
                         larger);
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
