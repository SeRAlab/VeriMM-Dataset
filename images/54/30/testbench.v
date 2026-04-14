`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg sel;
    wire [7:0] D;
    wire [7:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sel(sel),
        .D(D),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Simple Add/Sub (sel=0)", test_num);
        A = 8'd10;
        B = 8'd5;
        sel = 1'b0;

        #1;


        check_outputs(8'd5, 8'd15);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Simple Add/Sub Swapped (sel=1)", test_num);
        A = 8'd10;
        B = 8'd5;
        sel = 1'b1;

        #1;


        check_outputs(8'd15, 8'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Sum Overflow (sel=0)", test_num);
        A = 8'd200;
        B = 8'd100;
        sel = 1'b0;

        #1;


        check_outputs(8'd100, 8'd44);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Difference Underflow (sel=0)", test_num);
        A = 8'd10;
        B = 8'd20;
        sel = 1'b0;

        #1;


        check_outputs(8'd246, 8'd30);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Max Values Swapped (sel=1)", test_num);
        A = 8'hFF;
        B = 8'h01;
        sel = 1'b1;


        #1;



        check_outputs(8'd0, 8'd254);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Zero Inputs (sel=0)", test_num);
        A = 8'd0;
        B = 8'd0;
        sel = 1'b0;

        #1;


        check_outputs(8'd0, 8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Identical Inputs (sel=1)", test_num);
        A = 8'd128;
        B = 8'd128;
        sel = 1'b1;


        #1;



        check_outputs(8'd0, 8'd0);
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
        input [7:0] expected_D;
        input [7:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_D === (expected_D ^ D ^ expected_D) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: D=%h, S=%h",
                         D, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D=%h, S=%h",
                         expected_D, expected_S);
                $display("  Got:      D=%h, S=%h",
                         D, S);
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
