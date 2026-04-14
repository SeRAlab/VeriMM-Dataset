`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg IDL;
    reg [7:0] data_in0;
    reg [7:0] data_in1;
    reg [7:0] data_in2;
    reg [7:0] data_in3;
    reg valid0;
    reg valid1;
    reg valid2;
    reg valid3;
    wire [7:0] L1_in0;
    wire [7:0] L1_in1;
    wire [7:0] L1_in2;
    wire [7:0] L1_in3;
    wire L1_valid0;
    wire L1_valid1;
    wire L1_valid2;
    wire L1_valid3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IDL(IDL),
        .data_in0(data_in0),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .data_in3(data_in3),
        .valid0(valid0),
        .valid1(valid1),
        .valid2(valid2),
        .valid3(valid3),
        .L1_in0(L1_in0),
        .L1_in1(L1_in1),
        .L1_in2(L1_in2),
        .L1_in3(L1_in3),
        .L1_valid0(L1_valid0),
        .L1_valid1(L1_valid1),
        .L1_valid2(L1_valid2),
        .L1_valid3(L1_valid3)
    );
    task testcase001;

        begin
            $display("\nRunning testcase001: IDL is LOW (Disabled)");
            test_num = 1;
            IDL = 1'b0;
            data_in0 = 8'hAA; data_in1 = 8'hBB; data_in2 = 8'hCC; data_in3 = 8'hDD;
            valid0 = 1'b1;    valid1 = 1'b1;    valid2 = 1'b1;    valid3 = 1'b1;


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: IDL is HIGH (Forwarding Data)");
            test_num = 2;
            IDL = 1'b1;
            data_in0 = 8'h11; data_in1 = 8'h22; data_in2 = 8'h33; data_in3 = 8'h44;
            valid0 = 1'b1;    valid1 = 1'b0;    valid2 = 1'b1;    valid3 = 1'b0;


            #1;



            check_outputs(8'h11, 8'h22, 8'h33, 8'h44, 1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning testcase003: IDL transition to LOW (Disable Outputs)");
            test_num = 3;
            IDL = 1'b0;
            data_in0 = 8'hFF; data_in1 = 8'hEE; data_in2 = 8'hDD; data_in3 = 8'hCC;
            valid0 = 1'b1;    valid1 = 1'b1;    valid2 = 1'b1;    valid3 = 1'b1;


            #1;



            check_outputs(8'h00, 8'h00, 8'h00, 8'h00, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning testcase004: IDL HIGH with valids LOW");
            test_num = 4;
            IDL = 1'b1;
            data_in0 = 8'h55; data_in1 = 8'hAA; data_in2 = 8'h00; data_in3 = 8'hFF;
            valid0 = 1'b0;    valid1 = 1'b0;    valid2 = 1'b0;    valid3 = 1'b0;


            #1;



            check_outputs(8'h55, 8'hAA, 8'h00, 8'hFF, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning testcase005: Boundary Data Values with IDL HIGH");
            test_num = 5;
            IDL = 1'b1;
            data_in0 = 8'h00; data_in1 = 8'hFF; data_in2 = 8'h00; data_in3 = 8'hFF;
            valid0 = 1'b1;    valid1 = 1'b1;    valid2 = 1'b1;    valid3 = 1'b1;


            #1;



            check_outputs(8'h00, 8'hFF, 8'h00, 8'hFF, 1'b1, 1'b1, 1'b1, 1'b1);
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
        input [7:0] expected_L1_in0;
        input [7:0] expected_L1_in1;
        input [7:0] expected_L1_in2;
        input [7:0] expected_L1_in3;
        input expected_L1_valid0;
        input expected_L1_valid1;
        input expected_L1_valid2;
        input expected_L1_valid3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_L1_in0 === (expected_L1_in0 ^ L1_in0 ^ expected_L1_in0) &&
                expected_L1_in1 === (expected_L1_in1 ^ L1_in1 ^ expected_L1_in1) &&
                expected_L1_in2 === (expected_L1_in2 ^ L1_in2 ^ expected_L1_in2) &&
                expected_L1_in3 === (expected_L1_in3 ^ L1_in3 ^ expected_L1_in3) &&
                expected_L1_valid0 === (expected_L1_valid0 ^ L1_valid0 ^ expected_L1_valid0) &&
                expected_L1_valid1 === (expected_L1_valid1 ^ L1_valid1 ^ expected_L1_valid1) &&
                expected_L1_valid2 === (expected_L1_valid2 ^ L1_valid2 ^ expected_L1_valid2) &&
                expected_L1_valid3 === (expected_L1_valid3 ^ L1_valid3 ^ expected_L1_valid3)) begin
                $display("PASS");
                $display("  Outputs: L1_in0=%h, L1_in1=%h, L1_in2=%h, L1_in3=%h, L1_valid0=%b, L1_valid1=%b, L1_valid2=%b, L1_valid3=%b",
                         L1_in0, L1_in1, L1_in2, L1_in3, L1_valid0, L1_valid1, L1_valid2, L1_valid3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: L1_in0=%h, L1_in1=%h, L1_in2=%h, L1_in3=%h, L1_valid0=%b, L1_valid1=%b, L1_valid2=%b, L1_valid3=%b",
                         expected_L1_in0, expected_L1_in1, expected_L1_in2, expected_L1_in3, expected_L1_valid0, expected_L1_valid1, expected_L1_valid2, expected_L1_valid3);
                $display("  Got:      L1_in0=%h, L1_in1=%h, L1_in2=%h, L1_in3=%h, L1_valid0=%b, L1_valid1=%b, L1_valid2=%b, L1_valid3=%b",
                         L1_in0, L1_in1, L1_in2, L1_in3, L1_valid0, L1_valid1, L1_valid2, L1_valid3);
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
