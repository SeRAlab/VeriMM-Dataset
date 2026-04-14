`timescale 1ns/1ps

module adc_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_input;
    wire [3:0] range_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_decoder dut (
        .adc_input(adc_input),
        .range_output(range_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case 001: Minimum values (Range 0)");
        adc_input = 24'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Boundary of Range 0 and 1");
        adc_input = 24'd1;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Range 1 start");
        adc_input = 24'd2;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Range 1 end");
        adc_input = 24'd3;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Intermediate Range (Range 7: 14-15)");
        adc_input = 24'd14;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Intermediate Range (Range 7: 14-15)");
        adc_input = 24'd15;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Range 14 start (28-29)");
        adc_input = 24'd28;
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Range 14 end (28-29)");
        adc_input = 24'd29;
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case 009: Range 15 start (30-31)");
        adc_input = 24'd30;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case 010: Range 15 end (30-31)");
        adc_input = 24'd31;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test Case 011: Clamping (Input 32)");
        adc_input = 24'd32;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test Case 012: Clamping (Large value 1024)");
        adc_input = 24'd1024;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Test Case 013: Maximum 24-bit value clamping");
        adc_input = 24'hFFFFFF;
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
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        
        
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
        input [3:0] expected_range_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_range_output === (expected_range_output ^ range_output ^ expected_range_output)) begin
                $display("PASS");
                $display("  Outputs: range_output=%h",
                         range_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: range_output=%h",
                         expected_range_output);
                $display("  Got:      range_output=%h",
                         range_output);
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
