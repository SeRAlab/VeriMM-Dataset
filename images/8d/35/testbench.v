`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] adc_input;
    reg clk;
    wire dac_en;
    wire [31:0] dac_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adc_input(adc_input),
        .clk(clk),
        .dac_en(dac_en),
        .dac_output(dac_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Minimum ADC Input (0)", test_num);
        adc_input = 32'h0000_0000;
        @(posedge clk);
        #1;

        check_outputs(1'b0, 32'h0000_0000);
    end
    endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Threshold ADC Input (2^31 - 1)", test_num);
        adc_input = 32'h7FFF_FFFF;
        @(posedge clk);
        #1;

        check_outputs(1'b0, 32'h0000_0000);
    end
    endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Just Above Threshold (2^31)", test_num);
        adc_input = 32'h8000_0000;
        @(posedge clk);
        #1;

        check_outputs(1'b1, 32'h8000_0000);
    end
    endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Maximum ADC Input (2^32 - 1)", test_num);
        adc_input = 32'hFFFF_FFFF;
        @(posedge clk);
        #1;

        check_outputs(1'b1, 32'hFFFF_FFFF);
    end
    endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Random Low Value (0x12345678)", test_num);
        adc_input = 32'h1234_5678;
        @(posedge clk);
        #1;

        check_outputs(1'b0, 32'h0000_0000);
    end
    endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Random High Value (0xABCDEF01)", test_num);
        adc_input = 32'hABCD_EF01;
        @(posedge clk);
        #1;

        check_outputs(1'b1, 32'hABCD_EF01);
    end
    endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Input value 1", test_num);
        adc_input = 32'h0000_0001;
        @(posedge clk);
        #1;

        check_outputs(1'b0, 32'h0000_0000);
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
        input expected_dac_en;
        input [31:0] expected_dac_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dac_en === (expected_dac_en ^ dac_en ^ expected_dac_en) &&
                expected_dac_output === (expected_dac_output ^ dac_output ^ expected_dac_output)) begin
                $display("PASS");
                $display("  Outputs: dac_en=%b, dac_output=%h",
                         dac_en, dac_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dac_en=%b, dac_output=%h",
                         expected_dac_en, expected_dac_output);
                $display("  Got:      dac_en=%b, dac_output=%h",
                         dac_en, dac_output);
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
