`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg Cin;
    wire Cout;
    wire Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .Sum(Sum)
    );
    task testcase001;

        begin

            A = 4'b0000; B = 4'b0000; Cin = 1'b0;
            #1;

            check_outputs(4'b0000, 1'b0);
        end
        endtask

    task testcase002;

        begin

            A = 4'd5; B = 4'd3; Cin = 1'b0;
            #1;

            check_outputs(4'd8, 1'b0);
        end
        endtask

    task testcase003;

        begin

            A = 4'd10; B = 4'd5; Cin = 1'b0;
            #1;

            check_outputs(4'd15, 1'b0);
        end
        endtask

    task testcase004;

        begin

            A = 4'd15; B = 4'd1; Cin = 1'b0;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin

            A = 4'b0000; B = 4'b0000; Cin = 1'b1;
            #1;

            check_outputs(4'd1, 1'b0);
        end
        endtask

    task testcase006;

        begin

            A = 4'b1111; B = 4'b0000; Cin = 1'b1;
            #1;

            check_outputs(4'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin

            A = 4'b1111; B = 4'b1111; Cin = 1'b1;
            #1;

            check_outputs(4'b1111, 1'b1);
        end
        endtask

    task testcase008;

        begin

            A = 4'b1001; B = 4'b0110; Cin = 1'b0;
            #1;

            check_outputs(4'b1111, 1'b0);
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
        input expected_Cout;
        input expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Sum=%b",
                         Cout, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Sum=%b",
                         expected_Cout, expected_Sum);
                $display("  Got:      Cout=%b, Sum=%b",
                         Cout, Sum);
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
