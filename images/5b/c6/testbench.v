`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [8:0] Input;
    wire [8:0] Output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Input(Input),
        .Output(Output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All zeros", test_num);
        Input = 9'b000000000;
        #1;

        check_outputs(9'b000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: All ones", test_num);
        Input = 9'b111111111;
        #1;

        check_outputs(9'b111111111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Only MSB set", test_num);
        Input = 9'b100000000;
        #1;

        check_outputs(9'b100000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Only LSB set", test_num);
        Input = 9'b000000001;
        #1;

        check_outputs(9'b000000001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Alternating bits 101010101", test_num);
        Input = 9'b101010101;
        #1;

        check_outputs(9'b101010101);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Alternating bits 010101010", test_num);
        Input = 9'b010101010;
        #1;

        check_outputs(9'b010101010);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Mid-range value (0x0F5)", test_num);
        Input = 9'h0F5;
        #1;

        check_outputs(9'h0F5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Mid-range value (0x1AA)", test_num);
        Input = 9'h1AA;
        #1;

        check_outputs(9'h1AA);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Bottom 8 bits toggle with MSB fixed", test_num);
        Input = 9'b101100110;
        #1;

        check_outputs(9'b101100110);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Walking one pattern bit 4", test_num);
        Input = 9'b000010000;
        #1;

        check_outputs(9'b000010000);
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
        input [8:0] expected_Output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Output === (expected_Output ^ Output ^ expected_Output)) begin
                $display("PASS");
                $display("  Outputs: Output=%h",
                         Output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Output=%h",
                         expected_Output);
                $display("  Got:      Output=%h",
                         Output);
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
