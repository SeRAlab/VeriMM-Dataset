`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire Overflow;
    wire [7:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Overflow(Overflow),
        .Sum(Sum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Simple addition (10 + 20)", test_num);
        A = 8'd10; B = 8'd20;
        #1;

        check_outputs(1'b0, 8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Zero addition (0 + 0)", test_num);
        A = 8'd0; B = 8'd0;
        #1;

        check_outputs(1'b0, 8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Boundary value (255 + 0)", test_num);
        A = 8'hFF; B = 8'h00;
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Minimum overflow (128 + 128)", test_num);
        A = 8'd128; B = 8'd128;
        #1;

        check_outputs(1'b1, 8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Maximum overflow (255 + 255)", test_num);
        A = 8'hFF; B = 8'hFF;
        #1;

        check_outputs(1'b1, 8'hFE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Carry out check (200 + 100)", test_num);
        A = 8'd200; B = 8'd100;

        #1;


        check_outputs(1'b1, 8'd44);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Bit pattern (0xAA + 0x55)", test_num);
        A = 8'hAA; B = 8'h55;
        #1;

        check_outputs(1'b0, 8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Small overflow (255 + 1)", test_num);
        A = 8'd255; B = 8'd1;
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
        input expected_Overflow;
        input [7:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Overflow === (expected_Overflow ^ Overflow ^ expected_Overflow) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Overflow=%b, Sum=%h",
                         Overflow, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Overflow=%b, Sum=%h",
                         expected_Overflow, expected_Sum);
                $display("  Got:      Overflow=%b, Sum=%h",
                         Overflow, Sum);
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
