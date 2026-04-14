`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] endianswapper_0142495a_in;
    wire [31:0] endianswapper_0142495a_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .endianswapper_0142495a_in(endianswapper_0142495a_in),
        .endianswapper_0142495a_out(endianswapper_0142495a_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All Zeros", test_num);
        endianswapper_0142495a_in = 32'h00000000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: All Ones", test_num);
        endianswapper_0142495a_in = 32'hFFFFFFFF;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Sequential Pattern", test_num);
        endianswapper_0142495a_in = 32'h12345678;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Hex Pattern DEADBEEF", test_num);
        endianswapper_0142495a_in = 32'hDEADBEEF;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Alternating Bits 5", test_num);
        endianswapper_0142495a_in = 32'h55555555;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Alternating Bits A", test_num);
        endianswapper_0142495a_in = 32'hAAAAAAAA;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Single Bit High (MSB)", test_num);
        endianswapper_0142495a_in = 32'h80000000;
        #1;

        check_outputs(32'h80000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Single Bit High (LSB)", test_num);
        endianswapper_0142495a_in = 32'h00000001;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Walkthrough Pattern", test_num);
        endianswapper_0142495a_in = 32'hA5A5C3C3;
        #1;

        check_outputs(32'hA5A5C3C3);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Random-like Constant", test_num);
        endianswapper_0142495a_in = 32'h99663300;
        #1;

        check_outputs(32'h99663300);
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
        input [31:0] expected_endianswapper_0142495a_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_endianswapper_0142495a_out === (expected_endianswapper_0142495a_out ^ endianswapper_0142495a_out ^ expected_endianswapper_0142495a_out)) begin
                $display("PASS");
                $display("  Outputs: endianswapper_0142495a_out=%h",
                         endianswapper_0142495a_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: endianswapper_0142495a_out=%h",
                         expected_endianswapper_0142495a_out);
                $display("  Got:      endianswapper_0142495a_out=%h",
                         endianswapper_0142495a_out);
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
