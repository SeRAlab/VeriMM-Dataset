`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] m;
    reg [7:0] n;
    wire [7:0] out_add;
    wire [7:0] out_sub;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .m(m),
        .n(n),
        .out_add(out_add),
        .out_sub(out_sub)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition and Subtraction", test_num);
            m = 8'd10;
            n = 8'd5;
            #1;

            check_outputs(8'd15, 8'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero inputs", test_num);
            m = 8'd0;
            n = 8'd0;
            #1;

            check_outputs(8'd0, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition Overflow (Wrap-around)", test_num);
            m = 8'hFF;
            n = 8'h01;
            #1;

            check_outputs(8'h00, 8'hFE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Underflow (Wrap-around)", test_num);
            m = 8'd10;
            n = 8'd20;
            #1;

            check_outputs(8'd30, 8'd246);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values", test_num);
            m = 8'hFF;
            n = 8'hFF;
            #1;

            check_outputs(8'hFE, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            m = 8'hAA;
            n = 8'h55;
            #1;

            check_outputs(8'hFF, 8'h55);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of 2 Subtraction", test_num);
            m = 8'd128;
            n = 8'd1;
            #1;

            check_outputs(8'd129, 8'd127);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small M minus Large N", test_num);
            m = 8'h00;
            n = 8'hFF;
            #1;

            check_outputs(8'hFF, 8'h01);
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
        input [7:0] expected_out_add;
        input [7:0] expected_out_sub;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_add === (expected_out_add ^ out_add ^ expected_out_add) &&
                expected_out_sub === (expected_out_sub ^ out_sub ^ expected_out_sub)) begin
                $display("PASS");
                $display("  Outputs: out_add=%h, out_sub=%h",
                         out_add, out_sub);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_add=%h, out_sub=%h",
                         expected_out_add, expected_out_sub);
                $display("  Got:      out_add=%h, out_sub=%h",
                         out_add, out_sub);
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
