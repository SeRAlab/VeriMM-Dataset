`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] a;
    reg [9:0] b;
    wire [9:0] out;

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
            a = 10'd10;
            b = 10'd20;
            $display("Test %0d: a=%d, b=%d (Expect b)", test_num, a, b);
            #1;

            check_outputs(10'd20);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 10'd50;
            b = 10'd5;
            $display("Test %0d: a=%d, b=%d (Expect a)", test_num, a, b);
            #1;

            check_outputs(10'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 10'd100;
            b = 10'd100;
            $display("Test %0d: a=%d, b=%d (Expect equal)", test_num, a, b);
            #1;

            check_outputs(10'd100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 10'h000;
            b = 10'h3FF;
            $display("Test %0d: a=%h, b=%h (Expect b)", test_num, a, b);
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 10'h3FF;
            b = 10'h000;
            $display("Test %0d: a=%h, b=%h (Expect a)", test_num, a, b);
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 10'd511;
            b = 10'd512;
            $display("Test %0d: a=%d, b=%d (Boundary check)", test_num, a, b);
            #1;

            check_outputs(10'd512);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 10'h2AA;
            b = 10'h155;
            $display("Test %0d: a=%h, b=%h (Pattern check)", test_num, a, b);
            #1;

            check_outputs(10'h2AA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 10'd1;
            b = 10'd0;
            $display("Test %0d: a=%d, b=%d (Minimal diff)", test_num, a, b);
            #1;

            check_outputs(10'd1);
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
        input [9:0] expected_out;
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
