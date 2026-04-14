`timescale 1ns/1ps

module adc_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_value;
    wire [3:0] range;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_decoder dut (
        .adc_value(adc_value),
        .range(range)
    );
    task testcase001;

    begin
        test_num = 1;
        adc_value = 16'd0;
        $display("Test %0d: Input %d (Range 0 Min)", test_num, adc_value);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        adc_value = 16'd1023;
        $display("Test %0d: Input %d (Range 0 Max)", test_num, adc_value);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        adc_value = 16'd1024;
        $display("Test %0d: Input %d (Range 1 Min)", test_num, adc_value);
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        adc_value = 16'd2047;
        $display("Test %0d: Input %d (Range 1 Max)", test_num, adc_value);
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        adc_value = 16'd2048;
        $display("Test %0d: Input %d (Range 2 Min)", test_num, adc_value);
        #1;

        check_outputs(4'b0010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        adc_value = 16'd5120;
        $display("Test %0d: Input %d (Range 5 Min)", test_num, adc_value);
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        adc_value = 16'd8191;
        $display("Test %0d: Input %d (Range 7 Max)", test_num, adc_value);
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        adc_value = 16'd8192;
        $display("Test %0d: Input %d (Range 8 Min)", test_num, adc_value);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        adc_value = 16'd12287;
        $display("Test %0d: Input %d (Range 11 Max)", test_num, adc_value);
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        adc_value = 16'd13312;
        $display("Test %0d: Input %d (Range 13 Min)", test_num, adc_value);
        #1;

        check_outputs(4'b1101);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        adc_value = 16'd14336;
        $display("Test %0d: Input %d (Range 14 Min)", test_num, adc_value);
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        adc_value = 16'd15359;
        $display("Test %0d: Input %d (Range 14 Max)", test_num, adc_value);
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        adc_value = 16'd15360;
        $display("Test %0d: Input %d (Range 15 Min)", test_num, adc_value);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        adc_value = 16'd32768;
        $display("Test %0d: Input %d (Range 15 Mid)", test_num, adc_value);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        adc_value = 16'hFFFF;
        $display("Test %0d: Input %d (Range 15 Max/Saturation)", test_num, adc_value);
        #1;

        check_outputs(4'b1111);
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
        testcase014();
        testcase015();
        
        
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
