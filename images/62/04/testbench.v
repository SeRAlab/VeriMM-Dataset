`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    wire [63:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a == b (Zero Difference)", test_num);
            a = 64'hA5A5A5A5_5A5A5A5A;
            b = 64'hA5A5A5A5_5A5A5A5A;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a > b (Small positive difference)", test_num);
            a = 64'd100;
            b = 64'd40;
            #1;

            check_outputs(64'd60);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a < b (Small positive difference)", test_num);
            a = 64'd25;
            b = 64'd75;
            #1;

            check_outputs(64'd50);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a = Max, b = 0", test_num);
            a = 64'hFFFFFFFF_FFFFFFFF;
            b = 64'h00000000_00000000;
            #1;

            check_outputs(64'hFFFFFFFF_FFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: a = 0, b = Max", test_num);
            a = 64'h00000000_00000000;
            b = 64'hFFFFFFFF_FFFFFFFF;
            #1;

            check_outputs(64'hFFFFFFFF_FFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large difference (MSB flip)", test_num);
            a = 64'h80000000_00000000;
            b = 64'h7FFFFFFF_FFFFFFFF;
            #1;

            check_outputs(64'h1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary large values (a > b)", test_num);
            a = 64'hFEDCBA98_76543210;
            b = 64'h01234567_89ABCDEF;
            #1;

            check_outputs(64'hFDA97530_ECE97421);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Arbitrary large values (b > a)", test_num);
            a = 64'h11111111_11111111;
            b = 64'h22222222_22222222;
            #1;

            check_outputs(64'h11111111_11111111);
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
        input [63:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
