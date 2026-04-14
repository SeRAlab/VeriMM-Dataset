`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [10:0] A;
    reg [10:0] B;
    reg cIn;
    wire cOut;
    wire [10:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .cIn(cIn),
        .cOut(cOut),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Basic addition without carry-in", test_num);
        A = 11'd100;
        B = 11'd250;
        cIn = 1'b0;

        #1;


        check_outputs(1'b0, 11'd350);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Basic addition with carry-in", test_num);
        A = 11'd500;
        B = 11'd500;
        cIn = 1'b1;

        #1;


        check_outputs(1'b0, 11'd1001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Carry-out boundary (Sum exactly 2048)", test_num);
        A = 11'h7FF;
        B = 11'h001;
        cIn = 1'b0;

        #1;


        check_outputs(1'b1, 11'h000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Maximum values with carry-in", test_num);
        A = 11'h7FF;
        B = 11'h7FF;
        cIn = 1'b1;


        #1;



        check_outputs(1'b1, 11'h7FF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Zero inputs", test_num);
        A = 11'h000;
        B = 11'h000;
        cIn = 1'b0;

        #1;


        check_outputs(1'b0, 11'h000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Alternating bits", test_num);
        A = 11'h555;
        B = 11'h2AA;
        cIn = 1'b1;


        #1;



        check_outputs(1'b1, 11'h000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Mid-range addition", test_num);
        A = 11'd1024;
        B = 11'd512;
        cIn = 1'b0;

        #1;


        check_outputs(1'b0, 11'd1536);
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
        input expected_cOut;
        input [10:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cOut === (expected_cOut ^ cOut ^ expected_cOut) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: cOut=%b, out=%h",
                         cOut, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cOut=%b, out=%h",
                         expected_cOut, expected_out);
                $display("  Got:      cOut=%b, out=%h",
                         cOut, out);
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
