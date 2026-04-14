`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
    reg [1:0] select;
    wire [15:0] out;

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
        .select(select),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select input A (select = 00)", test_num);
        a = 16'hAAAA;
        b = 16'hBBBB;
        c = 16'hCCCC;
        d = 16'hDDDD;
        select = 2'b00;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select input B (select = 01)", test_num);
        a = 16'hAAAA;
        b = 16'h5555;
        c = 16'hCCCC;
        d = 16'hDDDD;
        select = 2'b01;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select input C (select = 10)", test_num);
        a = 16'h1111;
        b = 16'h2222;
        c = 16'h3333;
        d = 16'h4444;
        select = 2'b10;
        #1;

        check_outputs(16'h3333);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select input D (select = 11)", test_num);
        a = 16'hFFFF;
        b = 16'hEEEE;
        c = 16'hDDDD;
        d = 16'hCCCC;
        select = 2'b11;
        #1;

        check_outputs(16'hCCCC);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary conditions (All Zeros)", test_num);
        a = 16'h0000;
        b = 16'hFFFF;
        c = 16'hFFFF;
        d = 16'hFFFF;
        select = 2'b00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary conditions (All Ones)", test_num);
        a = 16'h0000;
        b = 16'h0000;
        c = 16'hFFFF;
        d = 16'h0000;
        select = 2'b10;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Bitwise walking 1 pattern", test_num);
        a = 16'h0001;
        b = 16'h0002;
        c = 16'h0004;
        d = 16'h0008;


        select = 2'b11;
        #1;

        check_outputs(16'h0008);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternate bit pattern", test_num);
        a = 16'h5A5A;
        b = 16'hA5A5;
        c = 16'hF0F0;
        d = 16'h0F0F;
        select = 2'b01;
        #1;

        check_outputs(16'hA5A5);
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
