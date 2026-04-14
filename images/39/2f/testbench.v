`timescale 1ns/1ps

module four_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [4:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    four_bit_adder dut (
        .A(A),
        .B(B),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'd0;
        B = 4'd0;
        $display("Test %0d: Zero Addition (0 + 0)", test_num);
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd5;
        B = 4'd3;
        $display("Test %0d: Simple Addition (5 + 3)", test_num);
        #1;

        check_outputs(5'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd15;
        B = 4'd0;
        $display("Test %0d: Max A plus Zero (15 + 0)", test_num);
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd8;
        B = 4'd8;
        $display("Test %0d: Boundary Carry Out (8 + 8)", test_num);
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd15;
        B = 4'd1;
        $display("Test %0d: Carry Out (15 + 1)", test_num);
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'd10;
        B = 4'd10;
        $display("Test %0d: Large Numbers (10 + 10)", test_num);
        #1;

        check_outputs(5'd20);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'd15;
        B = 4'd15;
        $display("Test %0d: Maximum Possible Sum (15 + 15)", test_num);
        #1;

        check_outputs(5'd30);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'd7;
        B = 4'd8;
        $display("Test %0d: Sum to 15 (7 + 8)", test_num);
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'd1;
        B = 4'd14;
        $display("Test %0d: Commutative Check Part 1 (1 + 14)", test_num);
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'd14;
        B = 4'd1;
        $display("Test %0d: Commutative Check Part 2 (14 + 1)", test_num);
        #1;

        check_outputs(5'd15);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("four_bit_adder Testbench");
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
        input [4:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Sum=%h",
                         Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Sum=%h",
                         expected_Sum);
                $display("  Got:      Sum=%h",
                         Sum);
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
