`timescale 1ns/1ps

module adc_converter_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_input;
    wire [11:0] digital_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_converter dut (
        .adc_input(adc_input),
        .digital_output(digital_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Zero Scale Input", test_num);
        adc_input = 24'h000000;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Full Scale Input", test_num);
        adc_input = 24'hFFFFFF;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Midpoint Scale Input", test_num);
        adc_input = 24'h800000;
        #1;

        check_outputs(12'h800);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Quarter Scale Input", test_num);
        adc_input = 24'h400000;
        #1;

        check_outputs(12'h400);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Minimum value for Bit 0 High", test_num);
        adc_input = 24'h001000;
        #1;

        check_outputs(12'h001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Maximum value for digital output 0", test_num);
        adc_input = 24'h000FFF;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: High Range Scale Input", test_num);
        adc_input = 24'hC00000;
        #1;

        check_outputs(12'hC00);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Pattern Input 1 (0xA5A...)", test_num);
        adc_input = 24'hA5A5A5;
        #1;

        check_outputs(12'hA5A);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Pattern Input 2 (0x5A5...)", test_num);
        adc_input = 24'h5A5A5A;
        #1;

        check_outputs(12'h5A5);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Boundary High Input", test_num);
        adc_input = 24'hFFF000;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_converter Testbench");
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
        input [11:0] expected_digital_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_digital_output === (expected_digital_output ^ digital_output ^ expected_digital_output)) begin
                $display("PASS");
                $display("  Outputs: digital_output=%h",
                         digital_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: digital_output=%h",
                         expected_digital_output);
                $display("  Got:      digital_output=%h",
                         digital_output);
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
