`timescale 1ns/1ps

module adc_processor_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_value;
    wire [3:0] range;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_processor dut (
        .adc_value(adc_value),
        .range(range)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Range 0 - Lower Bound (0)", test_num);
        adc_value = 16'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Range 0 - Upper Bound (1023)", test_num);
        adc_value = 16'd1023;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Range 1 - Lower Bound (1024)", test_num);
        adc_value = 16'd1024;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Range 1 - Upper Bound (2047)", test_num);
        adc_value = 16'd2047;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Range 2 - Lower Bound (2048)", test_num);
        adc_value = 16'd2048;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Range 2 - Upper Bound (3071)", test_num);
        adc_value = 16'd3071;
        #1;

        check_outputs(4'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Range 3 - Lower Bound (3072)", test_num);
        adc_value = 16'd3072;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Range 3 - Upper Bound (4095)", test_num);
        adc_value = 16'd4095;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Error Range - Lower Bound (4096)", test_num);
        adc_value = 16'd4096;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Error Range - Typical Value (10000)", test_num);
        adc_value = 16'd10000;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Error Range - Maximum Value (65535)", test_num);
        adc_value = 16'hFFFF;
        #1;

        check_outputs(4'd15);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_processor Testbench");
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
        testcase011();
        
        
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
        input [3:0] expected_range;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_range === (expected_range ^ range ^ expected_range)) begin
                $display("PASS");
                $display("  Outputs: range=%h",
                         range);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: range=%h",
                         expected_range);
                $display("  Got:      range=%h",
                         range);
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
