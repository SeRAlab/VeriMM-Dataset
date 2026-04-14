`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [2:0] sel;
    wire [31:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .sel(sel),
        .res(res)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=0 (res = {a+b, a})", test_num);
        a = 16'h1000;
        b = 16'h0500;
        c = 16'h0000;
        sel = 3'b000;
        #1;

        check_outputs(32'h15001000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=1 (res = {a-b, b})", test_num);
        a = 16'h2000;
        b = 16'h0100;
        c = 16'h0000;
        sel = 3'b001;
        #1;

        check_outputs(32'h1F000100);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=2 (res = {a+c, c})", test_num);
        a = 16'h1234;
        b = 16'h0000;
        c = 16'h1111;
        sel = 3'b010;
        #1;

        check_outputs(32'h23451111);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=3 (res = {a-c, a})", test_num);
        a = 16'hFFFF;
        b = 16'h0000;
        c = 16'h000F;
        sel = 3'b011;
        #1;

        check_outputs(32'hFFF0FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=4 (res = {b, b})", test_num);
        a = 16'h0000;
        b = 16'hABCD;
        c = 16'h0000;
        sel = 3'b100;
        #1;

        check_outputs(32'hABCDABCD);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=5 (res = {c, c})", test_num);
        a = 16'h0000;
        b = 16'h0000;
        c = 16'h55AA;
        sel = 3'b101;
        #1;

        check_outputs(32'h55AA55AA);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=6 (res = 32'bx)", test_num);
        a = 16'h1234;
        b = 16'h5678;
        c = 16'h9ABC;
        sel = 3'b110;
        #1;

        check_outputs(32'hxxxxxxxx);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=0 (Overflow a+b)", test_num);
        a = 16'hFFFF;
        b = 16'h0001;
        c = 16'h0000;
        sel = 3'b000;

        #1;


        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: sel=1 (Underflow a-b)", test_num);
        a = 16'h0000;
        b = 16'h0001;
        c = 16'h0000;
        sel = 3'b001;

        #1;


        check_outputs(32'hFFFF0001);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs zero", test_num);
        a = 16'h0000;
        b = 16'h0000;
        c = 16'h0000;
        sel = 3'b010;
        #1;

        check_outputs(32'h00000000);
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
        input [31:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
