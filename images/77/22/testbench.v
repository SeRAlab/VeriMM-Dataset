`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
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
        .d(d),
        .sel(sel),
        .res(res)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sum all inputs (sel=0)", test_num);
        a = 16'd100;
        b = 16'd200;
        c = 16'd300;
        d = 16'd400;
        sel = 3'b000;

        #1;


        check_outputs(32'd1000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: (a+b) - (c+d) (sel=1)", test_num);
        a = 16'd500;
        b = 16'd500;
        c = 16'd200;
        d = 16'd100;
        sel = 3'b001;

        #1;


        check_outputs(32'd700);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Concatenate {a, b} (sel=2)", test_num);
        a = 16'hDEAD;
        b = 16'hBEEF;
        c = 16'h0000;
        d = 16'h0000;
        sel = 3'b010;

        #1;


        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Concatenate {c, d} (sel=3)", test_num);
        a = 16'h0000;
        b = 16'h0000;
        c = 16'h1234;
        d = 16'h5678;
        sel = 3'b011;

        #1;


        check_outputs(32'h12345678);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sum a and c (sel=4)", test_num);
        a = 16'd1500;
        b = 16'd0;
        c = 16'd2500;
        d = 16'd0;
        sel = 3'b100;

        #1;


        check_outputs(32'd4000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sum b and d (sel=5)", test_num);
        a = 16'd0;
        b = 16'd8000;
        c = 16'd0;
        d = 16'd2000;
        sel = 3'b101;

        #1;


        check_outputs(32'd10000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Difference a - c (sel=6)", test_num);
        a = 16'd5000;
        b = 16'd0;
        c = 16'd1000;
        d = 16'd0;
        sel = 3'b110;

        #1;


        check_outputs(32'd4000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Difference b - d (sel=7)", test_num);
        a = 16'd0;
        b = 16'd9999;
        c = 16'd0;
        d = 16'd1111;
        sel = 3'b111;

        #1;


        check_outputs(32'd8888);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large sum (sel=0)", test_num);
        a = 16'hFFFF;
        b = 16'hFFFF;
        c = 16'hFFFF;
        d = 16'hFFFF;
        sel = 3'b000;

        #1;


        check_outputs(32'h0003FFFC);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Concatenate Zeros (sel=2)", test_num);
        a = 16'h0000;
        b = 16'h0000;
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
