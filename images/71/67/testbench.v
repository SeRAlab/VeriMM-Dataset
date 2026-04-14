`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
    reg [15:0] e;
    reg [15:0] f;
    reg [15:0] g;
    reg [15:0] h;
    reg [2:0] sel;
    wire [15:0] o;

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
        .e(e),
        .f(f),
        .g(g),
        .h(h),
        .sel(sel),
        .o(o)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 16'hAAAA; b = 16'h0000; c = 16'h0000; d = 16'h0000;
        e = 16'h0000; f = 16'h0000; g = 16'h0000; h = 16'h0000;
        sel = 3'b000;
        $display("Testcase %0d: Testing sel=000 (input a)", test_num);
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 16'h0000; b = 16'hBBBB; c = 16'h0000; d = 16'h0000;
        e = 16'h0000; f = 16'h0000; g = 16'h0000; h = 16'h0000;
        sel = 3'b001;
        $display("Testcase %0d: Testing sel=001 (input b)", test_num);
        #1;

        check_outputs(16'hBBBB);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 16'h0000; b = 16'h0000; c = 16'hCCCC; d = 16'h0000;
        e = 16'h0000; f = 16'h0000; g = 16'h0000; h = 16'h0000;
        sel = 3'b010;
        $display("Testcase %0d: Testing sel=010 (input c)", test_num);
        #1;

        check_outputs(16'hCCCC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 16'h0000; b = 16'h0000; c = 16'h0000; d = 16'hDDDD;
        e = 16'h0000; f = 16'h0000; g = 16'h0000; h = 16'h0000;
        sel = 3'b011;
        $display("Testcase %0d: Testing sel=011 (input d)", test_num);
        #1;

        check_outputs(16'hDDDD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 16'h0000; b = 16'h0000; c = 16'h0000; d = 16'h0000;
        e = 16'hEEEE; f = 16'h0000; g = 16'h0000; h = 16'h0000;
        sel = 3'b100;
        $display("Testcase %0d: Testing sel=100 (input e)", test_num);
        #1;

        check_outputs(16'hEEEE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 16'h0000; b = 16'h0000; c = 16'h0000; d = 16'h0000;
        e = 16'h0000; f = 16'hFFFF; g = 16'h0000; h = 16'h0000;
        sel = 3'b101;
        $display("Testcase %0d: Testing sel=101 (input f)", test_num);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 16'h0000; b = 16'h0000; c = 16'h0000; d = 16'h0000;
        e = 16'h0000; f = 16'h0000; g = 16'h1234; h = 16'h0000;
        sel = 3'b110;
        $display("Testcase %0d: Testing sel=110 (input g)", test_num);
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 16'h0000; b = 16'h0000; c = 16'h0000; d = 16'h0000;
        e = 16'h0000; f = 16'h0000; g = 16'h0000; h = 16'h5678;
        sel = 3'b111;
        $display("Testcase %0d: Testing sel=111 (input h)", test_num);
        #1;

        check_outputs(16'h5678);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 16'h1111; b = 16'h2222; c = 16'h3333; d = 16'h4444;
        e = 16'h5555; f = 16'h6666; g = 16'h7777; h = 16'h8888;
        sel = 3'b011;
        $display("Testcase %0d: Testing switch values with sel=011", test_num);
        #1;

        check_outputs(16'h4444);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 16'hFFFF; b = 16'hEEEE; c = 16'hDDDD; d = 16'hCCCC;
        e = 16'hBBBB; f = 16'hAAAA; g = 16'h9999; h = 16'h8888;
        sel = 3'b110;
        $display("Testcase %0d: Testing switch values with sel=110", test_num);
        #1;

        check_outputs(16'h9999);
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
        input [15:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
