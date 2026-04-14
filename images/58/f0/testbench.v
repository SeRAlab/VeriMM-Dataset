`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
    reg [15:0] e;
    wire [15:0] product;

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
        .product(product)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small product", test_num);
        a = 16'd2; b = 16'd3; c = 16'd4; d = 16'd5; e = 16'd6;
        #1;

        check_outputs(16'd720);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: First input zero", test_num);
        a = 16'd0; b = 16'd10; c = 16'd20; d = 16'd30; e = 16'd40;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Middle input zero", test_num);
        a = 16'd10; b = 16'd20; c = 16'd0; d = 16'd30; e = 16'd40;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Last input zero", test_num);
        a = 16'd10; b = 16'd20; c = 16'd30; d = 16'd40; e = 16'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All ones", test_num);
        a = 16'd1; b = 16'd1; c = 16'd1; d = 16'd1; e = 16'd1;
        #1;

        check_outputs(16'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Overflow truncation", test_num);
        a = 16'd100; b = 16'd100; c = 16'd10; d = 16'd1; e = 16'd1;
        #1;

        check_outputs(16'h86A0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiple zero inputs", test_num);
        a = 16'd0; b = 16'd5; c = 16'd0; d = 16'd12; e = 16'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Powers of 2", test_num);
        a = 16'd2; b = 16'd2; c = 16'd2; d = 16'd2; e = 16'd2;
        #1;

        check_outputs(16'd32);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max input single", test_num);
        a = 16'hFFFF; b = 16'd1; c = 16'd1; d = 16'd1; e = 16'd1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Prime numbers", test_num);
        a = 16'd2; b = 16'd3; c = 16'd5; d = 16'd7; e = 16'd11;
        #1;

        check_outputs(16'd2310);
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
        input [15:0] expected_product;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
