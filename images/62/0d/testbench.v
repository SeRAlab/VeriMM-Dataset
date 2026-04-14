`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] binary;
    wire [11:0] bcd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary(binary),
        .bcd(bcd)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Binary = 0 (Expected BCD = 000)", test_num);
        binary = 8'd0;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Binary = 1 (Expected BCD = 001)", test_num);
        binary = 8'd1;
        #1;

        check_outputs(12'h001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Binary = 9 (Expected BCD = 009)", test_num);
        binary = 8'd9;
        #1;

        check_outputs(12'h009);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Binary = 10 (Expected BCD = 010)", test_num);
        binary = 8'd10;
        #1;

        check_outputs(12'h010);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Binary = 42 (Expected BCD = 042)", test_num);
        binary = 8'd42;
        #1;

        check_outputs(12'h042);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Binary = 99 (Expected BCD = 099)", test_num);
        binary = 8'd99;
        #1;

        check_outputs(12'h099);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Binary = 100 (Expected BCD = 100)", test_num);
        binary = 8'd100;
        #1;

        check_outputs(12'h100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Binary = 123 (Expected BCD = 123)", test_num);
        binary = 8'd123;
        #1;

        check_outputs(12'h123);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Binary = 200 (Expected BCD = 200)", test_num);
        binary = 8'd200;
        #1;

        check_outputs(12'h200);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Binary = 255 (Expected BCD = 255)", test_num);
        binary = 8'd255;
        #1;

        check_outputs(12'h255);
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
        input [11:0] expected_bcd;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd === (expected_bcd ^ bcd ^ expected_bcd)) begin
                $display("PASS");
                $display("  Outputs: bcd=%h",
                         bcd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd=%h",
                         expected_bcd);
                $display("  Got:      bcd=%h",
                         bcd);
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
