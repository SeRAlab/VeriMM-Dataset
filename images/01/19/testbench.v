`timescale 1ns/1ps

module FixedPointMultiplier_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [31:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    FixedPointMultiplier dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Zero Multiplication", test_num);
        a = 16'h0000;
        b = 16'h0000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Positive Multiplication (0.5 * 0.5)", test_num);
        a = 16'h4000;
        b = 16'h4000;
        #1;

        check_outputs(32'h20000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Negative by Positive (-1.0 * 0.5)", test_num);
        a = 16'h8000;
        b = 16'h4000;
        #1;

        check_outputs(32'hC0000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Saturation Case (-1.0 * -1.0)", test_num);
        a = 16'h8000;
        b = 16'h8000;
        #1;

        check_outputs(32'h7FFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Max Positive (0.999 * 0.999)", test_num);
        a = 16'h7FFF;
        b = 16'h7FFF;
        #1;

        check_outputs(32'h7FFE0002);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Smallest Positive Product", test_num);
        a = 16'h0001;
        b = 16'h0001;
        #1;

        check_outputs(32'h00000002);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Mixed Sign Max Values", test_num);
        a = 16'h7FFF;
        b = 16'h8000;
        #1;

        check_outputs(32'h80020000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Small Negative Multiplication", test_num);
        a = 16'hFFFF;
        b = 16'h4000;
        #1;

        check_outputs(32'hFFFF8000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("FixedPointMultiplier Testbench");
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
