`timescale 1ns/1ps

module divider_2bit_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A;
    reg [1:0] B;
    wire [1:0] Quotient;
    wire [1:0] Remainder;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_2bit dut (
        .A(A),
        .B(B),
        .Quotient(Quotient),
        .Remainder(Remainder)
    );
    task testcase001;

        begin
            $display("Testcase 001: Division by Zero (A=0..3, B=0)");
            A = 2'd0; B = 2'd0; #1;
 check_outputs(2'd0, 2'd0);
            A = 2'd1; B = 2'd0; #1;
 check_outputs(2'd0, 2'd0);
            A = 2'd2; B = 2'd0; #1;
 check_outputs(2'd0, 2'd0);
            A = 2'd3; B = 2'd0; #1;
 check_outputs(2'd0, 2'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Division by One (A=0..3, B=1)");
            A = 2'd0; B = 2'd1; #1;
 check_outputs(2'd0, 2'd0);
            A = 2'd1; B = 2'd1; #1;
 check_outputs(2'd1, 2'd0);
            A = 2'd2; B = 2'd1; #1;
 check_outputs(2'd2, 2'd0);
            A = 2'd3; B = 2'd1; #1;
 check_outputs(2'd3, 2'd0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Division by Two (A=0..3, B=2)");
            A = 2'd0; B = 2'd2; #1;
 check_outputs(2'd0, 2'd0);
            A = 2'd1; B = 2'd2; #1;
 check_outputs(2'd0, 2'd1);
            A = 2'd2; B = 2'd2; #1;
 check_outputs(2'd1, 2'd0);
            A = 2'd3; B = 2'd2; #1;
 check_outputs(2'd1, 2'd1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Division by Three (A=0..3, B=3)");
            A = 2'd0; B = 2'd3; #1;
 check_outputs(2'd0, 2'd0);
            A = 2'd1; B = 2'd3; #1;
 check_outputs(2'd0, 2'd1);
            A = 2'd2; B = 2'd3; #1;
 check_outputs(2'd0, 2'd2);
            A = 2'd3; B = 2'd3; #1;
 check_outputs(2'd1, 2'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Dividend is zero, Divisor is non-zero");
            A = 2'd0; B = 2'd1; #1;
 check_outputs(2'd0, 2'd0);
            A = 2'd0; B = 2'd2; #1;
 check_outputs(2'd0, 2'd0);
            A = 2'd0; B = 2'd3; #1;
 check_outputs(2'd0, 2'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("divider_2bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input [1:0] expected_Quotient;
        input [1:0] expected_Remainder;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Quotient === (expected_Quotient ^ Quotient ^ expected_Quotient) &&
                expected_Remainder === (expected_Remainder ^ Remainder ^ expected_Remainder)) begin
                $display("PASS");
                $display("  Outputs: Quotient=%h, Remainder=%h",
                         Quotient, Remainder);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Quotient=%h, Remainder=%h",
                         expected_Quotient, expected_Remainder);
                $display("  Got:      Quotient=%h, Remainder=%h",
                         Quotient, Remainder);
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
