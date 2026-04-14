`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [15:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 8'd0;
        B = 8'd0;
        $display("Test %0d: A=%0d, B=%0d (Zero Multiplication)", test_num, A, B);
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 8'd255;
        B = 8'd0;
        $display("Test %0d: A=%0d, B=%0d (Multiply by Zero)", test_num, A, B);
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 8'd1;
        B = 8'd1;
        $display("Test %0d: A=%0d, B=%0d (Identity)", test_num, A, B);
        #1;

        check_outputs(16'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 8'd255;
        B = 8'd1;
        $display("Test %0d: A=%0d, B=%0d (Identity Max)", test_num, A, B);
        #1;

        check_outputs(16'd255);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 8'd255;
        B = 8'd255;
        $display("Test %0d: A=%0d, B=%0d (Maximum values)", test_num, A, B);
        #1;

        check_outputs(16'hFE01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 8'd16;
        B = 8'd16;
        $display("Test %0d: A=%0d, B=%0d (Powers of 2)", test_num, A, B);
        #1;

        check_outputs(16'd256);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 8'd123;
        B = 8'd45;
        $display("Test %0d: A=%0d, B=%0d (General values)", test_num, A, B);
        #1;

        check_outputs(16'd5535);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 8'hAA;
        B = 8'h55;
        $display("Test %0d: A=0x%h, B=0x%h (Alternating bit patterns)", test_num, A, B);
        #1;

        check_outputs(16'h3872);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 8'd2;
        B = 8'd128;
        $display("Test %0d: A=%0d, B=%0d (Power of 2 Shift)", test_num, A, B);
        #1;

        check_outputs(16'd256);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 8'd15;
        B = 8'd15;
        $display("Test %0d: A=%0d, B=%0d (Small Square)", test_num, A, B);
        #1;

        check_outputs(16'd225);
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
        input [15:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
