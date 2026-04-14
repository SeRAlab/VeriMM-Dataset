`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] X;
    reg [3:0] Y;
    wire EQ;
    wire LG;
    wire RG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .X(X),
        .Y(Y),
        .EQ(EQ),
        .LG(LG),
        .RG(RG)
    );
    task testcase001;

    begin
        test_num = 1;
        X = 4'd0; Y = 4'd0;
        $display("Test %0d: X=%d, Y=%d (Expect Equal)", test_num, X, Y);
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        X = 4'd15; Y = 4'd15;
        $display("Test %0d: X=%d, Y=%d (Expect Equal)", test_num, X, Y);
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        X = 4'd5; Y = 4'd5;
        $display("Test %0d: X=%d, Y=%d (Expect Equal)", test_num, X, Y);
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        X = 4'd0; Y = 4'd1;
        $display("Test %0d: X=%d, Y=%d (Expect LG)", test_num, X, Y);
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        X = 4'd1; Y = 4'd0;
        $display("Test %0d: X=%d, Y=%d (Expect RG)", test_num, X, Y);
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        X = 4'd0; Y = 4'd15;
        $display("Test %0d: X=%d, Y=%d (Expect LG)", test_num, X, Y);
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        X = 4'd15; Y = 4'd0;
        $display("Test %0d: X=%d, Y=%d (Expect RG)", test_num, X, Y);
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        X = 4'b1010; Y = 4'b0101;
        $display("Test %0d: X=%b, Y=%b (Expect RG)", test_num, X, Y);
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        X = 4'b0110; Y = 4'b0111;
        $display("Test %0d: X=%b, Y=%b (Expect LG)", test_num, X, Y);
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        X = 4'b1101; Y = 4'b1011;
        $display("Test %0d: X=%b, Y=%b (Expect RG)", test_num, X, Y);
        #1;

        check_outputs(0, 0, 1);
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
        input expected_EQ;
        input expected_LG;
        input expected_RG;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_EQ === (expected_EQ ^ EQ ^ expected_EQ) &&
                expected_LG === (expected_LG ^ LG ^ expected_LG) &&
                expected_RG === (expected_RG ^ RG ^ expected_RG)) begin
                $display("PASS");
                $display("  Outputs: EQ=%b, LG=%b, RG=%b",
                         EQ, LG, RG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EQ=%b, LG=%b, RG=%b",
                         expected_EQ, expected_LG, expected_RG);
                $display("  Got:      EQ=%b, LG=%b, RG=%b",
                         EQ, LG, RG);
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
