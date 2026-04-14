`timescale 1ns/1ps

module adc_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_value;
    wire [1:0] range_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_decoder dut (
        .adc_value(adc_value),
        .range_code(range_code)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Range 00 Lower Boundary (0)", test_num);
        adc_value = 16'd0;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Range 00 Upper Boundary (4095)", test_num);
        adc_value = 16'd4095;
        #1;

        check_outputs(2'b00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Range 01 Lower Boundary (4096)", test_num);
        adc_value = 16'd4096;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Range 01 Upper Boundary (8191)", test_num);
        adc_value = 16'd8191;
        #1;

        check_outputs(2'b01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Range 10 Lower Boundary (8192)", test_num);
        adc_value = 16'd8192;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Range 10 Upper Boundary (12287)", test_num);
        adc_value = 16'd12287;
        #1;

        check_outputs(2'b10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Range 11 Lower Boundary (12288)", test_num);
        adc_value = 16'd12288;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Range 11 Mid Value (32768)", test_num);
        adc_value = 16'd32768;
        #1;

        check_outputs(2'b11);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Range 11 Upper Boundary (65535)", test_num);
        adc_value = 16'd65535;
        #1;

        check_outputs(2'b11);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_decoder Testbench");
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
        input [1:0] expected_range_code;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_range_code === (expected_range_code ^ range_code ^ expected_range_code)) begin
                $display("PASS");
                $display("  Outputs: range_code=%h",
                         range_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: range_code=%h",
                         expected_range_code);
                $display("  Got:      range_code=%h",
                         range_code);
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
