`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire a_lt_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .a_lt_b(a_lt_b)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Equality (a=0, b=0)", test_num);
        a = 32'h00000000;
        b = 32'h00000000;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Less Than (a=5, b=10)", test_num);
        a = 32'h00000005;
        b = 32'h0000000A;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Greater Than (a=10, b=5)", test_num);
        a = 32'h0000000A;
        b = 32'h00000005;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary - Maximum Value (a=FFFFFFFF, b=0)", test_num);
        a = 32'hFFFFFFFF;
        b = 32'h00000000;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary - Minimum Difference Positive (a=0, b=FFFFFFFF)", test_num);
        a = 32'h00000000;
        b = 32'hFFFFFFFF;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sign Bit Flip - Positive (a=7FFFFFFF, b=80000000)", test_num);
        a = 32'h7FFFFFFF;
        b = 32'h80000000;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Sign Bit Flip - Negative (a=80000000, b=7FFFFFFF)", test_num);
        a = 32'h80000000;
        b = 32'h7FFFFFFF;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large Negative (a=FFFFFFFF, b=FFFFFFFF)", test_num);
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Specific MSB Logic (a=FFFFFFFF, b=7FFFFFFF)", test_num);
        a = 32'hFFFFFFFF;
        b = 32'h7FFFFFFF;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large Integers (a=12345678, b=87654321)", test_num);
        a = 32'h12345678;
        b = 32'h87654321;

        #1;


        check_outputs(1'b1);
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
        input expected_a_lt_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_a_lt_b === (expected_a_lt_b ^ a_lt_b ^ expected_a_lt_b)) begin
                $display("PASS");
                $display("  Outputs: a_lt_b=%b",
                         a_lt_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_lt_b=%b",
                         expected_a_lt_b);
                $display("  Got:      a_lt_b=%b",
                         a_lt_b);
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
