`timescale 1ns/1ps

module adder_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_4bit dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'd0;
        b = 4'd0;
        $display("Test Case 001: Addition of zeros - a=%d, b=%d", a, b);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'd5;
        b = 4'd3;
        $display("Test Case 002: Simple addition - a=%d, b=%d", a, b);
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'd10;
        b = 4'd5;
        $display("Test Case 003: Addition reaching max value - a=%d, b=%d", a, b);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'd15;
        b = 4'd1;
        $display("Test Case 004: Overflow wrap-around (15+1=0) - a=%d, b=%d", a, b);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'd8;
        b = 4'd8;
        $display("Test Case 005: Overflow wrap-around (8+8=0) - a=%d, b=%d", a, b);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'd15;
        b = 4'd15;
        $display("Test Case 006: Max values addition (15+15=14) - a=%d, b=%d", a, b);
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'd7;
        b = 4'd9;
        $display("Test Case 007: Crossing boundary - a=%d, b=%d", a, b);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'd12;
        b = 4'd6;
        $display("Test Case 008: Overflow check - a=%d, b=%d", a, b);
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 4'd1;
        b = 4'd2;
        $display("Test Case 009: Small values - a=%d, b=%d", a, b);
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 4'd4;
        b = 4'd4;
        $display("Test Case 010: Power of two addition - a=%d, b=%d", a, b);
        #1;

        check_outputs(4'd8);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_4bit Testbench");
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
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
