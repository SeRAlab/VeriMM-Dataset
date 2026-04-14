`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    reg [1:0] sel;
    wire [7:0] y;

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
        .sel(sel),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Select input A (sel=00)", test_num);
        a = 8'hAA;
        b = 8'h55;
        c = 8'h00;
        d = 8'hFF;
        sel = 2'b00;
        #10;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Select input B (sel=01)", test_num);
        a = 8'hAA;
        b = 8'h55;
        c = 8'h00;
        d = 8'hFF;
        sel = 2'b01;
        #10;
        #1;

        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Select input C (sel=10)", test_num);
        a = 8'hAA;
        b = 8'h55;
        c = 8'h12;
        d = 8'hFF;
        sel = 2'b10;
        #10;
        #1;

        check_outputs(8'h12);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Select input D (sel=11)", test_num);
        a = 8'hAA;
        b = 8'h55;
        c = 8'h12;
        d = 8'hE7;
        sel = 2'b11;
        #10;
        #1;

        check_outputs(8'hE7);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: All inputs identical", test_num);
        a = 8'hBC;
        b = 8'hBC;
        c = 8'hBC;
        d = 8'hBC;
        sel = 2'b10;
        #10;
        #1;

        check_outputs(8'hBC);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Walking zeros pattern", test_num);
        a = 8'hFE;
        b = 8'hFD;
        c = 8'hFB;
        d = 8'hF7;
        sel = 2'b01;
        #10;
        #1;

        check_outputs(8'hFD);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Maximum value selection", test_num);
        a = 8'h00;
        b = 8'h00;
        c = 8'h00;
        d = 8'hFF;
        sel = 2'b11;
        #10;
        #1;

        check_outputs(8'hFF);
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
        input [7:0] expected_y;
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
