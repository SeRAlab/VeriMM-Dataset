`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero multiplication (0 * 0)", test_num);
        a = 8'h00;
        b = 8'h00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplicative identity (15 * 1)", test_num);
        a = 8'd15;
        b = 8'd01;
        #1;

        check_outputs(16'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple multiplication (10 * 5)", test_num);
        a = 8'd10;
        b = 8'd05;
        #1;

        check_outputs(16'd50);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Power of 2 (16 * 16)", test_num);
        a = 8'd16;
        b = 8'd16;
        #1;

        check_outputs(16'd256);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large unsigned multiplication (200 * 10)", test_num);
        a = 8'd200;
        b = 8'd10;
        #1;

        check_outputs(16'd2000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum 8-bit unsigned product (255 * 255)", test_num);
        a = 8'hFF;
        b = 8'hFF;

        #1;


        check_outputs(16'hFE01);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating bit patterns (0xAA * 0x02)", test_num);
        a = 8'hAA;
        b = 8'h02;

        #1;


        check_outputs(16'h0154);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mixed bits (0x55 * 0x03)", test_num);
        a = 8'h55;
        b = 8'h03;

        #1;


        check_outputs(16'h00FF);
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
        input [15:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
