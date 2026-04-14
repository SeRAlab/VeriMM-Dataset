`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    wire [63:0] prod;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .prod(prod)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero multiplication (0 * 0)", test_num);
        a = 64'h0;
        b = 64'h0;
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplication by zero (12345 * 0)", test_num);
        a = 64'd12345;
        b = 64'h0;
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identity multiplication (0xABC * 1)", test_num);
        a = 64'hABC;
        b = 64'h1;
        #1;

        check_outputs(64'hABC);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small positive integers (50 * 20)", test_num);
        a = 64'd50;
        b = 64'd20;
        #1;

        check_outputs(64'd1000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power of 2 (2^10 * 2^10)", test_num);
        a = 64'h400;
        b = 64'h400;
        #1;

        check_outputs(64'h100000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max 64-bit value * 1", test_num);
        a = 64'hFFFFFFFFFFFFFFFF;
        b = 64'h1;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max 64-bit value * 2 (Truncated)", test_num);
        a = 64'hFFFFFFFFFFFFFFFF;
        b = 64'h2;

        #1;


        check_outputs(64'hFFFFFFFFFFFFFFFE);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: (2^32-1)^2", test_num);
        a = 64'h00000000FFFFFFFF;
        b = 64'h00000000FFFFFFFF;


        #1;



        check_outputs(64'hFFFFFFFF00000001);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bits (0xAAA... * 2)", test_num);
        a = 64'hAAAAAAAAAAAAAAAA;
        b = 64'h2;

        #1;


        check_outputs(64'h5555555555555554);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multi-word multiplication check", test_num);
        a = 64'h0123456789ABCDEF;
        b = 64'h0000000000000010;
        #1;

        check_outputs(64'h123456789ABCDEF0);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: (-1 * -1) in 2's complement", test_num);
        a = 64'hFFFFFFFFFFFFFFFF;
        b = 64'hFFFFFFFFFFFFFFFF;

        #1;


        check_outputs(64'h0000000000000001);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 2^32 * 2^32 (Result should be 0 mod 2^64)", test_num);
        a = 64'h0000000100000000;
        b = 64'h0000000100000000;
        #1;

        check_outputs(64'h0000000000000000);
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
        testcase011();
        testcase012();
        
        
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
        input [63:0] expected_prod;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_prod === (expected_prod ^ prod ^ expected_prod)) begin
                $display("PASS");
                $display("  Outputs: prod=%h",
                         prod);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: prod=%h",
                         expected_prod);
                $display("  Got:      prod=%h",
                         prod);
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
