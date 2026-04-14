`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg cin;
    wire cout;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd0;
        B = 4'd0;
        cin = 1'b0;
        $display("Testcase %0d: All zeros (0 + 0 + 0)", test_num);
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd5;
        B = 4'd3;
        cin = 1'b0;
        $display("Testcase %0d: Simple addition without carry (5 + 3 + 0)", test_num);
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd4;
        B = 4'd4;
        cin = 1'b1;
        $display("Testcase %0d: Simple addition with carry-in (4 + 4 + 1)", test_num);
        #1;

        check_outputs(1'b0, 4'd9);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd7;
        B = 4'd8;
        cin = 1'b0;
        $display("Testcase %0d: Max sum without carry-out (7 + 8 + 0 = 15)", test_num);
        #1;

        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd8;
        B = 4'd8;
        cin = 1'b0;
        $display("Testcase %0d: Carry-out boundary (8 + 8 + 0 = 16)", test_num);
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'd15;
        B = 4'd0;
        cin = 1'b1;
        $display("Testcase %0d: Carry-out via carry-in (15 + 0 + 1 = 16)", test_num);
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'd10;
        B = 4'd10;
        cin = 1'b0;
        $display("Testcase %0d: Overflow with remainder (10 + 10 = 20)", test_num);
        #1;

        check_outputs(1'b1, 4'd4);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'd15;
        B = 4'd15;
        cin = 1'b1;
        $display("Testcase %0d: Maximum possible result (15 + 15 + 1 = 31)", test_num);
        #1;

        check_outputs(1'b1, 4'd15);
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
        input expected_cout;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%b, sum=%h",
                         cout, sum);
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
