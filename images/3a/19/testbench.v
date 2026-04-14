`timescale 1ns/1ps

module adc_processor_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] adc_input;
    reg valid;
    wire [9:0] adc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_processor dut (
        .adc_input(adc_input),
        .valid(valid),
        .adc_output(adc_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Valid low", test_num);
        adc_input = 8'hFF;
        valid = 1'b0;
        #1;

        check_outputs(10'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 0x00, Valid high", test_num);
        adc_input = 8'h00;
        valid = 1'b1;
        #1;

        check_outputs(10'h000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 0x01, Valid high", test_num);
        adc_input = 8'h01;
        valid = 1'b1;
        #1;

        check_outputs(10'h004);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 0x40, Valid high", test_num);
        adc_input = 8'h40;
        valid = 1'b1;
        #1;

        check_outputs(10'h100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 0x7F, Valid high", test_num);
        adc_input = 8'h7F;
        valid = 1'b1;
        #1;

        check_outputs(10'h1FC);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 0x80, Valid high", test_num);
        adc_input = 8'h80;
        valid = 1'b1;
        #1;

        check_outputs(10'h200);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 0xFF, Valid high", test_num);
        adc_input = 8'hFF;
        valid = 1'b1;
        #1;

        check_outputs(10'h3FC);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Input 0xAA, Toggle valid", test_num);
        adc_input = 8'hAA;
        valid = 1'b1;
        #5;
        valid = 1'b0;
        #1;

        check_outputs(10'h000);
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
        input [9:0] expected_adc_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adc_output === (expected_adc_output ^ adc_output ^ expected_adc_output)) begin
                $display("PASS");
                $display("  Outputs: adc_output=%h",
                         adc_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_output=%h",
                         expected_adc_output);
                $display("  Got:      adc_output=%h",
                         adc_output);
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
