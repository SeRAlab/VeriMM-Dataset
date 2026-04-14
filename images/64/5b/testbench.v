`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg hex;
    reg [7:0] num;
    wire [7:0] bcd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .hex(hex),
        .num(num),
        .bcd(bcd)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Decimal Mode - Zero", test_num);
        hex = 0;
        num = 8'd0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Decimal Mode - 42", test_num);
        hex = 0;
        num = 8'd42;
        #1;

        check_outputs(8'h42);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Decimal Mode - 99", test_num);
        hex = 0;
        num = 8'd99;
        #1;

        check_outputs(8'h99);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Mode - Zero", test_num);
        hex = 1;
        num = 8'h00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Mode - 0x12", test_num);
        hex = 1;
        num = 8'h12;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Mode - 0xAB", test_num);
        hex = 1;
        num = 8'hAB;
        #1;

        check_outputs(8'hAB);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Mode - 0xFF", test_num);
        hex = 1;
        num = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Decimal Mode - 7", test_num);
        hex = 0;
        num = 8'd7;
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Decimal Mode - 10", test_num);
        hex = 0;
        num = 8'd10;
        #1;

        check_outputs(8'h10);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Hex Mode - 16 (0x10)", test_num);
        hex = 1;
        num = 8'd16;
        #1;

        check_outputs(8'h10);
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
        input [7:0] expected_bcd;
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
