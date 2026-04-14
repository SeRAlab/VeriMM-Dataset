`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [7:0] min;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .min(min)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 'a' is minimum", test_num);
        a = 8'h05; b = 8'h10; c = 8'h20; d = 8'h30;
        #1;

        check_outputs(8'h05);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 'b' is minimum", test_num);
        a = 8'hFF; b = 8'h42; c = 8'h80; d = 8'hAA;
        #1;

        check_outputs(8'h42);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 'c' is minimum", test_num);
        a = 8'd100; b = 8'd90; c = 8'd10; d = 8'd20;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 'd' is minimum", test_num);
        a = 8'd55; b = 8'd44; c = 8'd33; d = 8'd22;
        #1;

        check_outputs(8'd22);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs are equal", test_num);
        a = 8'h77; b = 8'h77; c = 8'h77; d = 8'h77;
        #1;

        check_outputs(8'h77);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Minimum is zero", test_num);
        a = 8'd12; b = 8'd0; c = 8'd255; d = 8'd1;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs are max value", test_num);
        a = 8'hFF; b = 8'hFF; c = 8'hFF; d = 8'hFF;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Two inputs equal and minimum", test_num);
        a = 8'd15; b = 8'd15; c = 8'd30; d = 8'd45;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Three inputs equal and minimum", test_num);
        a = 8'd200; b = 8'd50; c = 8'd50; d = 8'd50;
        #1;

        check_outputs(8'd50);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Extreme spread (0 vs 255)", test_num);
        a = 8'hFF; b = 8'h00; c = 8'hFE; d = 8'h01;
        #1;

        check_outputs(8'h00);
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
        input [7:0] expected_min;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_min === (expected_min ^ min ^ expected_min)) begin
                $display("PASS");
                $display("  Outputs: min=%h",
                         min);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: min=%h",
                         expected_min);
                $display("  Got:      min=%h",
                         min);
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
