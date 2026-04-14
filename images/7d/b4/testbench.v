`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] bin;
    wire [2:0] dec;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bin(bin),
        .dec(dec)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Binary Input 0", test_num);
        bin = 4'b0000;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Binary Input 3 (In Range)", test_num);
        bin = 4'b0011;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Binary Input 7 (Max In Range)", test_num);
        bin = 4'b0111;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Binary Input 8 (Out of Range)", test_num);
        bin = 4'b1000;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Binary Input 10 (Out of Range)", test_num);
        bin = 4'b1010;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Binary Input 15 (Max Value, Out of Range)", test_num);
        bin = 4'b1111;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Binary Input 5 (In Range)", test_num);
        bin = 4'b0101;
        #1;

        check_outputs(3'd5);
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
        input [2:0] expected_dec;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dec === (expected_dec ^ dec ^ expected_dec)) begin
                $display("PASS");
                $display("  Outputs: dec=%h",
                         dec);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dec=%h",
                         expected_dec);
                $display("  Got:      dec=%h",
                         dec);
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
