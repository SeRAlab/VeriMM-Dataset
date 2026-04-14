`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] result_im;
    wire [7:0] result_re;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .result_im(result_im),
        .result_re(result_re)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: All Zeros", test_num);
        a = 8'h00; b = 8'h00;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Identity Real", test_num);
        a = 8'h10; b = 8'h10;
        #1;

        check_outputs(8'h00, 8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Identity Imaginary Squared", test_num);
        a = 8'h01; b = 8'h01;
        #1;

        check_outputs(8'h00, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Basic Mixed Values", test_num);
        a = 8'h32; b = 8'h41;
        #1;

        check_outputs(8'h0B, 8'h0A);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Negative Real Result", test_num);
        a = 8'h23; b = 8'h23;
        #1;

        check_outputs(8'h0C, 8'hFB);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Max Imaginary Sum", test_num);
        a = 8'hFF; b = 8'hFF;
        #1;

        check_outputs(8'hC2, 8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Large Negative Real", test_num);
        a = 8'h1F; b = 8'h1F;
        #1;

        check_outputs(8'h1E, 8'h20);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Real Zeroing", test_num);
        a = 8'h0F; b = 8'hF0;
        #1;

        check_outputs(8'hE1, 8'h00);
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
        input [7:0] expected_result_im;
        input [7:0] expected_result_re;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result_im === (expected_result_im ^ result_im ^ expected_result_im) &&
                expected_result_re === (expected_result_re ^ result_re ^ expected_result_re)) begin
                $display("PASS");
                $display("  Outputs: result_im=%h, result_re=%h",
                         result_im, result_re);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_im=%h, result_re=%h",
                         expected_result_im, expected_result_re);
                $display("  Got:      result_im=%h, result_re=%h",
                         result_im, result_re);
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
