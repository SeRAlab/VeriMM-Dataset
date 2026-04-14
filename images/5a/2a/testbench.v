`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] imagPart;
    reg [11:0] realPart;
    wire [11:0] maximun;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .imagPart(imagPart),
        .realPart(realPart),
        .maximun(maximun)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        imagPart = 12'd100;
        realPart = 12'd200;
        $display("Test Case 001: realPart > imagPart (200 > 100)");
        #1;

        check_outputs(12'd200);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        imagPart = 12'd500;
        realPart = 12'd150;
        $display("Test Case 002: imagPart > realPart (500 > 150)");
        #1;

        check_outputs(12'd500);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        imagPart = 12'd1024;
        realPart = 12'd1024;
        $display("Test Case 003: imagPart == realPart (1024 == 1024)");
        #1;

        check_outputs(12'd1024);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        imagPart = 12'h000;
        realPart = 12'hFFF;
        $display("Test Case 004: Maximum 12-bit value vs Zero");
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        imagPart = 12'hFFF;
        realPart = 12'h000;
        $display("Test Case 005: Zero vs Maximum 12-bit value");
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        imagPart = 12'd2048;
        realPart = 12'd2047;
        $display("Test Case 006: Boundary values (2048 > 2047)");
        #1;

        check_outputs(12'd2048);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        imagPart = 12'd0;
        realPart = 12'd0;
        $display("Test Case 007: Both values zero");
        #1;

        check_outputs(12'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        imagPart = 12'hABC;
        realPart = 12'h123;
        $display("Test Case 008: Hexadecimal values (ABC > 123)");
        #1;

        check_outputs(12'hABC);
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
        input [11:0] expected_maximun;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_maximun === (expected_maximun ^ maximun ^ expected_maximun)) begin
                $display("PASS");
                $display("  Outputs: maximun=%h",
                         maximun);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: maximun=%h",
                         expected_maximun);
                $display("  Got:      maximun=%h",
                         maximun);
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
