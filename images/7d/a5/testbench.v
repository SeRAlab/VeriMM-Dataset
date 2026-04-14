`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg [31:0] Cin;
    wire Cout;
    wire [31:0] Sum;

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
        test_num = 1;
        A = 32'h0; B = 32'h0; Cin = 32'h0;
        #1;

        check_outputs(1'b0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 32'h12345678; B = 32'h11111111; Cin = 32'h0;
        #1;

        check_outputs(1'b0, 32'h23456789);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 32'h00000001; B = 32'h00000001; Cin = 32'h1;
        #1;

        check_outputs(1'b0, 32'h00000003);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 32'hFFFFFFFF; B = 32'h00000000; Cin = 32'h1;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 32'h0000FFFF; B = 32'h00000000; Cin = 32'h1;
        #1;

        check_outputs(1'b0, 32'h00010000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 32'h55555555; B = 32'hAAAAAAAA; Cin = 32'h0;
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 32'h55555555; B = 32'hAAAAAAAA; Cin = 32'h1;
        #1;

        check_outputs(1'b1, 32'h00000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 32'hFFFFFFFF; B = 32'hFFFFFFFF; Cin = 32'h1;
        #1;

        check_outputs(1'b1, 32'hFFFFFFFF);
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
        input [31:0] expected_Sum;
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
