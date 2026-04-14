`timescale 1ns/1ps

module adc_processor_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_input;
    wire [3:0] quant_level;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_processor dut (
        .adc_input(adc_input),
        .quant_level(quant_level)
    );
    task testcase001;

    begin
        test_num = 1;
        adc_input = 16'd0;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        adc_input = 16'd2047;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        adc_input = 16'd2048;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        adc_input = 16'd4096;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        adc_input = 16'd30719;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        adc_input = 16'd32768;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        adc_input = 16'd40960;
        #1;

        check_outputs(4'd10);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        adc_input = 16'd59392;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        adc_input = 16'd63488;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        adc_input = 16'hFFFF;
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
        input [3:0] expected_quant_level;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_quant_level === (expected_quant_level ^ quant_level ^ expected_quant_level)) begin
                $display("PASS");
                $display("  Outputs: quant_level=%h",
                         quant_level);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: quant_level=%h",
                         expected_quant_level);
                $display("  Got:      quant_level=%h",
                         quant_level);
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
