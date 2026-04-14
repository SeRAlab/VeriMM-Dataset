`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A_in;
    reg clock;
    reg reset;
    wire [4:0] A;
    wire CS2;
    wire CS3;
    wire CS4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A_in(A_in),
        .clock(clock),
        .reset(reset),
        .A(A),
        .CS2(CS2),
        .CS3(CS3),
        .CS4(CS4)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Input A_in = 5'h00", test_num);
        reset = 1;
        A_in = 5'h00;
        #20;
        reset = 0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(5'h1F, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Input A_in = 5'h1F", test_num);
        reset = 1;
        A_in = 5'h1F;
        #20;
        reset = 0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(5'h00, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Input A_in = 5'h0A", test_num);
        reset = 1;
        A_in = 5'h0A;
        #20;
        reset = 0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(5'h15, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Input A_in = 5'h15", test_num);
        reset = 1;
        A_in = 5'h15;
        #20;
        reset = 0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(5'h0A, 1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Input A_in = 5'h10", test_num);
        reset = 1;
        A_in = 5'h10;
        #20;
        reset = 0;
        @(posedge clock);
        #2;
        #1;

        check_outputs(5'h0F, 1'b0, 1'b0, 1'b0);
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
        input [4:0] expected_A;
        input expected_CS2;
        input expected_CS3;
        input expected_CS4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A === (expected_A ^ A ^ expected_A) &&
                expected_CS2 === (expected_CS2 ^ CS2 ^ expected_CS2) &&
                expected_CS3 === (expected_CS3 ^ CS3 ^ expected_CS3) &&
                expected_CS4 === (expected_CS4 ^ CS4 ^ expected_CS4)) begin
                $display("PASS");
                $display("  Outputs: A=%h, CS2=%b, CS3=%b, CS4=%b",
                         A, CS2, CS3, CS4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A=%h, CS2=%b, CS3=%b, CS4=%b",
                         expected_A, expected_CS2, expected_CS3, expected_CS4);
                $display("  Got:      A=%h, CS2=%b, CS3=%b, CS4=%b",
                         A, CS2, CS3, CS4);
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
