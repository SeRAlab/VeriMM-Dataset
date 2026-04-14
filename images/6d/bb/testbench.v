`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire carry;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .carry(carry),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 8'd0;
        B = 8'd0;
        $display("Test Case %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 8'd15;
        B = 8'd27;
        $display("Test Case %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 8'd42);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 8'd128;
        B = 8'd127;
        $display("Test Case %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b0, 8'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 8'd255;
        B = 8'd1;
        $display("Test Case %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(1'b1, 8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 8'd200;
        B = 8'd100;
        $display("Test Case %0d: A=%d, B=%d", test_num, A, B);

        #1;


        check_outputs(1'b1, 8'd44);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 8'hFF;
        B = 8'hFF;
        $display("Test Case %0d: A=%h, B=%h", test_num, A, B);

        #1;


        check_outputs(1'b1, 8'hFE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 8'b10101010;
        B = 8'b01010101;
        $display("Test Case %0d: A=%b, B=%b", test_num, A, B);
        #1;

        check_outputs(1'b0, 8'b11111111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 8'h80;
        B = 8'h80;
        $display("Test Case %0d: A=%h, B=%h", test_num, A, B);
        #1;

        check_outputs(1'b1, 8'h00);
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
        input expected_carry;
        input [7:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, sum=%h",
                         carry, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, sum=%h",
                         expected_carry, expected_sum);
                $display("  Got:      carry=%b, sum=%h",
                         carry, sum);
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
