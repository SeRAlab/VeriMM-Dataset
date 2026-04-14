`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] char0;
    reg [3:0] char1;
    reg [3:0] char2;
    reg [3:0] char3;
    reg [3:0] state;
    wire [3:0] char;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .char0(char0),
        .char1(char1),
        .char2(char2),
        .char3(char3),
        .state(state),
        .char(char)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Selecting char0 (state 0001)", test_num);
        char0 = 4'hA; char1 = 4'h0; char2 = 4'h0; char3 = 4'h0;
        state = 4'b0001;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Selecting char1 (state 1101)", test_num);
        char0 = 4'h0; char1 = 4'hB; char2 = 4'h0; char3 = 4'h0;
        state = 4'b1101;
        #1;

        check_outputs(4'hB);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Selecting char2 (state 1001)", test_num);
        char0 = 4'h0; char1 = 4'h0; char2 = 4'hC; char3 = 4'h0;
        state = 4'b1001;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Selecting char3 (state 0101)", test_num);
        char0 = 4'h0; char1 = 4'h0; char2 = 4'h0; char3 = 4'hD;
        state = 4'b0101;
        #1;

        check_outputs(4'hD);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Retention Check (Hold char3 value)", test_num);

        char3 = 4'hE;
        state = 4'b0101;
        #5;

        state = 4'b0000;
        char3 = 4'h0;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Retention Check (Transition between invalid states)", test_num);

        char0 = 4'h7;
        state = 4'b0001;
        #5;

        state = 4'b1111;
        char0 = 4'hF;
        #5;

        state = 4'b0010;
        #1;

        check_outputs(4'h7);
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
        input [3:0] expected_char;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_char === (expected_char ^ char ^ expected_char)) begin
                $display("PASS");
                $display("  Outputs: char=%h",
                         char);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: char=%h",
                         expected_char);
                $display("  Got:      char=%h",
                         char);
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
