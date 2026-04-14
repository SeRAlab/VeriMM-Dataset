`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] a_in;
    reg [5:0] b_in;
    wire [11:0] c_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_in(a_in),
        .b_in(b_in),
        .c_out(c_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 20 / 4 (Basic Division)", test_num);
        a_in = 6'd20; b_in = 6'd4;
        #1;

        check_outputs(12'h140);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 31 / 6 (With Remainder)", test_num);
        a_in = 6'd31; b_in = 6'd6;
        #1;

        check_outputs(12'h141);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 7 / 10 (Dividend < Divisor)", test_num);
        a_in = 6'd7; b_in = 6'd10;
        #1;

        check_outputs(12'h007);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 0 / 12 (Zero Dividend)", test_num);
        a_in = 6'd0; b_in = 6'd12;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 31 / 1 (Max Positive / 1)", test_num);
        a_in = 6'd31; b_in = 6'd1;
        #1;

        check_outputs(12'h7C0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 15 / 15 (Dividend == Divisor)", test_num);
        a_in = 6'd15; b_in = 6'd15;
        #1;

        check_outputs(12'h040);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 10 / 0 (Division by Zero)", test_num);
        a_in = 6'd10; b_in = 6'd0;
        #1;

        check_outputs(12'bx);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: -32 / 2 (Negative a_in)", test_num);
        a_in = 6'b100000; b_in = 6'd2;
        #1;

        check_outputs(12'bx);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: 10 / -1 (Negative b_in)", test_num);
        a_in = 6'd10; b_in = 6'b111111;
        #1;

        check_outputs(12'bx);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: -5 / -5 (Both Negative)", test_num);
        a_in = 6'b111011; b_in = 6'b111011;
        #1;

        check_outputs(12'bx);
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
        input [11:0] expected_c_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c_out === (expected_c_out ^ c_out ^ expected_c_out)) begin
                $display("PASS");
                $display("  Outputs: c_out=%h",
                         c_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_out=%h",
                         expected_c_out);
                $display("  Got:      c_out=%h",
                         c_out);
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
