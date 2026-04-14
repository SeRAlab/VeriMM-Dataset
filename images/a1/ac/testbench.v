`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] KEY;
    wire [7:0] HEX0;
    wire [7:0] HEX1;
    wire [7:0] HEX2;
    wire [7:0] HEX3;
    wire [7:0] HEX4;
    wire [7:0] HEX5;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .KEY(KEY),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3),
        .HEX4(HEX4),
        .HEX5(HEX5)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nRunning Testcase %0d: KEY[0]=0, KEY[1]=0 (Display Message)", test_num);
        KEY = 2'b00;


        #1;



        check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nRunning Testcase %0d: KEY[0]=0, KEY[1]=1 (Display Message)", test_num);
        KEY = 2'b01;

        #1;


        check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nRunning Testcase %0d: KEY[0]=1, KEY[1]=0 (Segments Turned OFF)", test_num);
        KEY = 2'b10;

        #1;


        check_outputs(8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nRunning Testcase %0d: KEY[0]=1, KEY[1]=1 (Segments Turned OFF)", test_num);
        KEY = 2'b11;

        #1;


        check_outputs(8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'hFF);
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
        input [7:0] expected_HEX0;
        input [7:0] expected_HEX1;
        input [7:0] expected_HEX2;
        input [7:0] expected_HEX3;
        input [7:0] expected_HEX4;
        input [7:0] expected_HEX5;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_HEX0 === (expected_HEX0 ^ HEX0 ^ expected_HEX0) &&
                expected_HEX1 === (expected_HEX1 ^ HEX1 ^ expected_HEX1) &&
                expected_HEX2 === (expected_HEX2 ^ HEX2 ^ expected_HEX2) &&
                expected_HEX3 === (expected_HEX3 ^ HEX3 ^ expected_HEX3) &&
                expected_HEX4 === (expected_HEX4 ^ HEX4 ^ expected_HEX4) &&
                expected_HEX5 === (expected_HEX5 ^ HEX5 ^ expected_HEX5)) begin
                $display("PASS");
                $display("  Outputs: HEX0=%h, HEX1=%h, HEX2=%h, HEX3=%h, HEX4=%h, HEX5=%h",
                         HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: HEX0=%h, HEX1=%h, HEX2=%h, HEX3=%h, HEX4=%h, HEX5=%h",
                         expected_HEX0, expected_HEX1, expected_HEX2, expected_HEX3, expected_HEX4, expected_HEX5);
                $display("  Got:      HEX0=%h, HEX1=%h, HEX2=%h, HEX3=%h, HEX4=%h, HEX5=%h",
                         HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
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
