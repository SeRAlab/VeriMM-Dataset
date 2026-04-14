`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg Cin;
    wire Cout;
    wire [7:0] Sum;

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
        test_num = test_num + 1;
        $display("Test Case %0d: All zeros", test_num);
        A = 8'h00; B = 8'h00; Cin = 0;
        #1;

        check_outputs(1'b0, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Carry-in only", test_num);
        A = 8'h00; B = 8'h00; Cin = 1;
        #1;

        check_outputs(1'b0, 8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Basic addition (no carry-out)", test_num);
        A = 8'h12; B = 8'h34; Cin = 0;
        #1;

        check_outputs(1'b0, 8'h46);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max sum 255 (no carry-out)", test_num);
        A = 8'hFE; B = 8'h01; Cin = 0;
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sum exactly 256 (carry-out set)", test_num);
        A = 8'hFF; B = 8'h01; Cin = 0;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max values FF + FF + 1", test_num);
        A = 8'hFF; B = 8'hFF; Cin = 1;
        #1;

        check_outputs(1'b1, 8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bits (AA + 55)", test_num);
        A = 8'hAA; B = 8'h55; Cin = 0;
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bits with carry-in (AA + 55 + 1)", test_num);
        A = 8'hAA; B = 8'h55; Cin = 1;
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
        input expected_Cout;
        input [7:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Sum=%h",
                         Cout, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Sum=%h",
                         expected_Cout, expected_Sum);
                $display("  Got:      Cout=%b, Sum=%h",
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
