`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] S;
    reg [31:0] in;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .S(S),
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        S = 3'b000;
        in = 32'hAAAA_AAA0;
        $display("Test Case 001: S=0, nibble=0");
        #1;

        check_outputs(get_expected_7seg(4'h0));
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        S = 3'b000;
        in = 32'h0000_000F;
        $display("Test Case 002: S=0, nibble=F");
        #1;

        check_outputs(get_expected_7seg(4'hF));
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        S = 3'b001;
        in = 32'h0000_00A0;
        $display("Test Case 003: S=1, nibble=A");
        #1;

        check_outputs(get_expected_7seg(4'hA));
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        S = 3'b011;
        in = 32'h0000_5000;
        $display("Test Case 004: S=3, nibble=5");
        #1;

        check_outputs(get_expected_7seg(4'h5));
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        S = 3'b111;
        in = 32'h1000_0000;
        $display("Test Case 005: S=7, nibble=1");
        #1;

        check_outputs(get_expected_7seg(4'h1));
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        S = 3'b111;
        in = 32'hE000_0000;
        $display("Test Case 006: S=7, nibble=E");
        #1;

        check_outputs(get_expected_7seg(4'hE));
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        S = 3'b100;
        in = 32'h0009_0000;
        $display("Test Case 007: S=4, nibble=9");
        #1;

        check_outputs(get_expected_7seg(4'h9));
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        in = 32'h1234_5678;
        S = 3'b010;
        $display("Test Case 008: Multi-nibble input, S=2, nibble=6");
        #1;

        check_outputs(get_expected_7seg(4'h6));
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
