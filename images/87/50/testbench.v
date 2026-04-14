`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in1;
    reg [15:0] in2;
    wire carry;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .carry(carry),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Zero Addition", test_num);
        in1 = 16'h0000;
        in2 = 16'h0000;
        #1;

        check_outputs(1'b0, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Small Addition No Carry", test_num);
        in1 = 16'h1234;
        in2 = 16'h4321;
        #1;

        check_outputs(1'b0, 16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Boundary - Max Value No Carry", test_num);
        in1 = 16'hFFFE;
        in2 = 16'h0001;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Boundary - Carry Generation (Zero Result)", test_num);
        in1 = 16'hFFFF;
        in2 = 16'h0001;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: MSB Addition Carry", test_num);
        in1 = 16'h8000;
        in2 = 16'h8000;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Max Input Addition", test_num);
        in1 = 16'hFFFF;
        in2 = 16'hFFFF;
        #1;

        check_outputs(1'b1, 16'hFFFE);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Alternating Bit Patterns", test_num);
        in1 = 16'hAAAA;
        in2 = 16'h5555;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Intermediate Carry Chain", test_num);
        in1 = 16'h00FF;
        in2 = 16'h0001;
        #1;

        check_outputs(1'b0, 16'h0100);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Large Values with Carry", test_num);
        in1 = 16'hABCD;
        in2 = 16'hBCDE;

        #1;


        check_outputs(1'b1, 16'h68AB);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: One Side Maximum", test_num);
        in1 = 16'hFFFF;
        in2 = 16'h0000;
        #1;

        check_outputs(1'b0, 16'hFFFF);
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
        input expected_carry;
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, out=%h",
                         carry, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, out=%h",
                         expected_carry, expected_out);
                $display("  Got:      carry=%b, out=%h",
                         carry, out);
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
