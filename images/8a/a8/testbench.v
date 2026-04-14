`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    reg [7:0] e;
    wire [7:0] out;

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
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 8'h00; b = 8'h00; c = 8'h00; d = 8'h00; e = 8'h00;
            $display("Test %0d: All Zeros Check", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 8'hFF; b = 8'h0F; c = 8'hF0; d = 8'h00; e = 8'h01;
            $display("Test %0d: Overflow and Logic Check", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 8'hAA; b = 8'h55; c = 8'hCC; d = 8'h33; e = 8'h10;
            $display("Test %0d: Complementary Patterns Check", test_num);
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 8'hF0; b = 8'hF0; c = 8'h0F; d = 8'h0F; e = 8'hA5;
            $display("Test %0d: Identity Logic and Offset", test_num);
            #1;

            check_outputs(8'hA4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 8'hFF; b = 8'hFF; c = 8'hFF; d = 8'hFF; e = 8'hFF;
            $display("Test %0d: All Ones Logic Check", test_num);
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_out;
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
