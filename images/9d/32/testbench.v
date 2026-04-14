`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [31:0] c;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication by zero (a=0)", test_num);
        a = 16'h0000;
        b = 16'h1234;
        c = 32'hABCD_EF12;

        #1;


        check_outputs(32'hABCD_EF12);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiplication by zero (b=0)", test_num);
        a = 16'hFFFF;
        b = 16'h0000;
        c = 32'h1234_5678;

        #1;


        check_outputs(32'h1234_5678);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic multiplication without offset (c=0)", test_num);
        a = 16'd10;
        b = 16'd20;
        c = 32'd0;

        #1;


        check_outputs(32'h0000_00C8);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic MAC operation", test_num);
        a = 16'd50;
        b = 16'd100;
        c = 32'd5000;

        #1;


        check_outputs(32'h0000_2710);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum 16-bit multiplication", test_num);
        a = 16'hFFFF;
        b = 16'hFFFF;
        c = 32'h0;

        #1;


        check_outputs(32'hFFFE_0001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: MAC with overflow (32-bit truncation)", test_num);
        a = 16'hFFFF;
        b = 16'hFFFF;
        c = 32'h0001_FFFF;

        #1;


        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Powers of 2 multiplication", test_num);
        a = 16'h0100;
        b = 16'h0080;
        c = 32'h0000_0001;

        #1;


        check_outputs(32'h0000_8001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Large offset value", test_num);
        a = 16'h0002;
        b = 16'h0003;
        c = 32'hFFFF_FFF0;

        #1;


        check_outputs(32'hFFFF_FFF6);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Random arbitrary values", test_num);
        a = 16'd123;
        b = 16'd456;
        c = 32'd789;

        #1;


        check_outputs(32'h0000_DE2D);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max result with max offset", test_num);
        a = 16'hFFFF;
        b = 16'hFFFF;
        c = 32'hFFFF_FFFF;

        #1;


        check_outputs(32'hFFFE_0000);
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
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
