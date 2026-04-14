`timescale 1ns/1ps

module multiplier_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg enable;
    reg reset;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_module dut (
        .a(a),
        .b(b),
        .enable(enable),
        .reset(reset),
        .product(product)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset Priority (a=5, b=5, reset=1, en=1)", test_num);
        reset = 1;
        enable = 1;
        a = 4'd5;
        b = 4'd5;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple Multiplication (a=2, b=3, en=1)", test_num);
        reset = 1; #10;
        reset = 0;
        enable = 1;
        a = 4'd2;
        b = 4'd3;
        #10;
        #1;

        check_outputs(8'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Values (a=15, b=15, en=1)", test_num);
        reset = 1; #10;
        reset = 0;
        enable = 1;
        a = 4'd15;
        b = 4'd15;
        #10;
        #1;

        check_outputs(8'd225);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Multiplication (a=0, b=10, en=1)", test_num);
        reset = 1; #10;
        reset = 0;
        enable = 1;
        a = 4'd0;
        b = 4'd10;
        #10;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication by One (a=1, b=13, en=1)", test_num);
        reset = 1; #10;
        reset = 0;
        enable = 1;
        a = 4'd1;
        b = 4'd13;
        #10;
        #1;

        check_outputs(8'd13);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Prime Numbers (a=7, b=11, en=1)", test_num);
        reset = 1; #10;
        reset = 0;
        enable = 1;
        a = 4'd7;
        b = 4'd11;
        #10;
        #1;

        check_outputs(8'd77);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Powers of Two (a=4, b=8, en=1)", test_num);
        reset = 1; #10;
        reset = 0;
        enable = 1;
        a = 4'd4;
        b = 4'd8;
        #10;
        #1;

        check_outputs(8'd32);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large/Small Mix (a=12, b=4, en=1)", test_num);
        reset = 1; #10;
        reset = 0;
        enable = 1;
        a = 4'd12;
        b = 4'd4;
        #10;
        #1;

        check_outputs(8'd48);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_module Testbench");
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
        input [7:0] expected_product;
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
