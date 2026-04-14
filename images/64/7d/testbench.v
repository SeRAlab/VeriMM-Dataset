`timescale 1ns/1ps

module Multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [31:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    Multiplier dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 16'h0000;
        b = 16'h0000;
        $display("Test Case 001: a=%0d, b=%0d", a, b);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 16'hFFFF;
        b = 16'h0000;
        $display("Test Case 002: a=%0d, b=%0d", a, b);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 16'h0001;
        b = 16'h0001;
        $display("Test Case 003: a=%0d, b=%0d", a, b);
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 16'd12345;
        b = 16'h0001;
        $display("Test Case 004: a=%0d, b=%0d", a, b);
        #1;

        check_outputs(32'd12345);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 16'd10;
        b = 16'd20;
        $display("Test Case 005: a=%0d, b=%0d", a, b);
        #1;

        check_outputs(32'd200);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 16'd256;
        b = 16'd256;
        $display("Test Case 006: a=%0d, b=%0d", a, b);
        #1;

        check_outputs(32'd65536);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 16'hFFFF;
        b = 16'hFFFF;
        $display("Test Case 007: a=%0d, b=%0d", a, b);

        #1;


        check_outputs(32'hFFFE0001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 16'hAAAA;
        b = 16'h5555;
        $display("Test Case 008: a=%h, b=%h", a, b);

        #1;


        check_outputs(32'h38E31C1E);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 16'd1234;
        b = 16'd5678;
        $display("Test Case 009: a=%0d, b=%0d", a, b);
        #1;

        check_outputs(32'd7006652);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 16'h8000;
        b = 16'd2;
        $display("Test Case 010: a=%h, b=%0d", a, b);
        #1;

        check_outputs(32'h00010000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("Multiplier Testbench");
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
        input [31:0] expected_product;
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
