`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] input1;
    reg [2:0] input2;
    reg [3:0] input3;
    reg [4:0] input4;
    reg [5:0] input5;
    wire [6:0] output1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input1(input1),
        .input2(input2),
        .input3(input3),
        .input4(input4),
        .input5(input5),
        .output1(output1)
    );
    task testcase001;

        begin
            test_num = 1;
            input1 = 2'b00;
            input2 = 3'b000;
            input3 = 4'b0000;
            input4 = 5'b00000;
            input5 = 6'b000000;
            $display("Testcase %03d: All Zeros", test_num);
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            input1 = 2'b11;
            input2 = 3'b100;
            input3 = 4'b1000;
            input4 = 5'b10000;
            input5 = 6'b110000;
            $display("Testcase %03d: Target bits set to 1, others 0", test_num);
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            input1 = 2'b10;
            input2 = 3'b011;
            input3 = 4'b0111;
            input4 = 5'b01111;
            input5 = 6'b001111;
            $display("Testcase %03d: Input1 active, others non-target bits active", test_num);
            #1;

            check_outputs(7'h40);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            input1 = 2'b00;
            input2 = 3'b100;
            input3 = 4'b1000;
            input4 = 5'b10000;
            input5 = 6'b000000;
            $display("Testcase %03d: Input2,3,4 MSBs active", test_num);
            #1;

            check_outputs(7'h1C);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            input1 = 2'b00;
            input2 = 3'b011;
            input3 = 4'b0111;
            input4 = 5'b01111;
            input5 = 6'b110000;
            $display("Testcase %03d: Input5 bits 5:4 active", test_num);
            #1;

            check_outputs(7'h03);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            input1 = 2'b01;
            input2 = 3'b111;
            input3 = 4'b0101;
            input4 = 5'b11111;
            input5 = 6'b010101;
            $display("Testcase %03d: Mixed bit pattern", test_num);
            #1;

            check_outputs(7'h35);
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
        input [6:0] expected_output1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output1 === (expected_output1 ^ output1 ^ expected_output1)) begin
                $display("PASS");
                $display("  Outputs: output1=%h",
                         output1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output1=%h",
                         expected_output1);
                $display("  Got:      output1=%h",
                         output1);
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
