`timescale 1ns/1ps

module ADC_24_to_12_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_in;
    wire [11:0] adc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ADC_24_to_12 dut (
        .adc_in(adc_in),
        .adc_out(adc_out)
    );
    task testcase001;

    begin
        test_num = 1;
        adc_in = 24'h000000;
        $display("Testcase %0d: Input = %h (All zeros)", test_num, adc_in);
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        adc_in = 24'hFFFFFF;
        $display("Testcase %0d: Input = %h (All ones)", test_num, adc_in);
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        adc_in = 24'hABCDEF;
        $display("Testcase %0d: Input = %h (Checking upper 12 bits)", test_num, adc_in);
        #1;

        check_outputs(12'hABC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        adc_in = 24'h000FFF;
        $display("Testcase %0d: Input = %h (Lower 12 bits are 1s)", test_num, adc_in);
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        adc_in = 24'hFFF000;
        $display("Testcase %0d: Input = %h (Upper 12 bits are 1s)", test_num, adc_in);
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        adc_in = 24'h555555;
        $display("Testcase %0d: Input = %h", test_num, adc_in);
        #1;

        check_outputs(12'h555);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        adc_in = 24'hAAAAAA;
        $display("Testcase %0d: Input = %h", test_num, adc_in);
        #1;

        check_outputs(12'hAAA);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        adc_in = 24'h800000;
        $display("Testcase %0d: Input = %h (Midpoint)", test_num, adc_in);
        #1;

        check_outputs(12'h800);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ADC_24_to_12 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [11:0] expected_adc_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adc_out === (expected_adc_out ^ adc_out ^ expected_adc_out)) begin
                $display("PASS");
                $display("  Outputs: adc_out=%h",
                         adc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_out=%h",
                         expected_adc_out);
                $display("  Got:      adc_out=%h",
                         adc_out);
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
