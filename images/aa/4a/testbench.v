`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    wire [7:0] Q;
    wire R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .Q(Q),
        .R(R)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A = 0 (Minimum value, Even)", test_num);
        A = 8'd0;
        #1;

        check_outputs(8'd0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A = 1 (Odd)", test_num);
        A = 8'd1;
        #1;

        check_outputs(8'd0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A = 2 (Even)", test_num);
        A = 8'd2;
        #1;

        check_outputs(8'd1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A = 255 (Maximum value, Odd)", test_num);
        A = 8'd255;
        #1;

        check_outputs(8'd127, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A = 128 (Power of 2, Even)", test_num);
        A = 8'd128;
        #1;

        check_outputs(8'd64, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A = 127 (Max 7-bit, Odd)", test_num);
        A = 8'd127;
        #1;

        check_outputs(8'd63, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A = 170 (Alternating bits 10101010, Even)", test_num);
        A = 8'hAA;
        #1;

        check_outputs(8'h55, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A = 85 (Alternating bits 01010101, Odd)", test_num);
        A = 8'h55;
        #1;

        check_outputs(8'd42, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A = 100 (Decimal hundred, Even)", test_num);
        A = 8'd100;
        #1;

        check_outputs(8'd50, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Input A = 254 (Even)", test_num);
        A = 8'd254;
        #1;

        check_outputs(8'd127, 1'b0);
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
        input [7:0] expected_Q;
        input expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, R=%b",
                         Q, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, R=%b",
                         expected_Q, expected_R);
                $display("  Got:      Q=%h, R=%b",
                         Q, R);
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
