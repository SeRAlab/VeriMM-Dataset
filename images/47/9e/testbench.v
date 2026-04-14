`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg CIN;
    reg MODE;
    wire [15:0] Q;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .CIN(CIN),
        .MODE(MODE),
        .Q(Q),
        .overflow(overflow)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 16'h0005; B = 16'h000A; CIN = 0; MODE = 0;
        #1;

        check_outputs(16'h000F, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 16'h00FF; B = 16'h0001; CIN = 1; MODE = 0;
        #1;

        check_outputs(16'h0101, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 16'h7FFF; B = 16'h0001; CIN = 0; MODE = 0;
        #1;

        check_outputs(16'h8000, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 16'h8000; B = 16'hFFFF; CIN = 0; MODE = 0;
        #1;

        check_outputs(16'h7FFF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 16'h000A; B = 16'h0005; CIN = 1; MODE = 1;
        #1;

        check_outputs(16'h0005, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 16'h000A; B = 16'h0005; CIN = 0; MODE = 1;
        #1;

        check_outputs(16'h0004, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 16'h7FFF; B = 16'hFFFF; CIN = 1; MODE = 1;
        #1;

        check_outputs(16'h8000, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 16'h8000; B = 16'h0001; CIN = 1; MODE = 1;
        #1;

        check_outputs(16'h7FFF, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 16'hFFFF; B = 16'hFFFF; CIN = 0; MODE = 0;
        #1;

        check_outputs(16'hFFFE, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 16'h1234; B = 16'h1234; CIN = 1; MODE = 1;
        #1;

        check_outputs(16'h0000, 1'b0);
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
        input [15:0] expected_Q;
        input expected_overflow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, overflow=%b",
                         Q, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, overflow=%b",
                         expected_Q, expected_overflow);
                $display("  Got:      Q=%h, overflow=%b",
                         Q, overflow);
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
