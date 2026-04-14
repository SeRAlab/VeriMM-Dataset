`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    wire [15:0] f;

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
        .f(f)
    );
    task testcase001;

    begin
        test_num = 1;
        {a, b, c, d} = 4'b0000;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        {a, b, c, d} = 4'b0001;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        {a, b, c, d} = 4'b0010;
        #1;

        check_outputs(16'h0004);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        {a, b, c, d} = 4'b0011;
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        {a, b, c, d} = 4'b0100;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        {a, b, c, d} = 4'b0101;
        #1;

        check_outputs(16'h0020);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        {a, b, c, d} = 4'b0110;
        #1;

        check_outputs(16'h0040);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        {a, b, c, d} = 4'b0111;
        #1;

        check_outputs(16'h0080);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        {a, b, c, d} = 4'b1000;
        #1;

        check_outputs(16'h0100);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        {a, b, c, d} = 4'b1001;
        #1;

        check_outputs(16'h0200);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        {a, b, c, d} = 4'b1010;
        #1;

        check_outputs(16'h0400);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        {a, b, c, d} = 4'b1011;
        #1;

        check_outputs(16'h0800);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        {a, b, c, d} = 4'b1100;
        #1;

        check_outputs(16'h1000);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        {a, b, c, d} = 4'b1101;
        #1;

        check_outputs(16'h2000);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        {a, b, c, d} = 4'b1110;
        #1;

        check_outputs(16'h4000);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        {a, b, c, d} = 4'b1111;
        #1;

        check_outputs(16'h8000);
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
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [15:0] expected_f;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f === (expected_f ^ f ^ expected_f)) begin
                $display("PASS");
                $display("  Outputs: f=%h",
                         f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%h",
                         expected_f);
                $display("  Got:      f=%h",
                         f);
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
