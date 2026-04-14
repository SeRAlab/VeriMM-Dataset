`timescale 1ns/1ps

module adc_output_processor_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_input;
    wire [7:0] adc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_output_processor dut (
        .adc_input(adc_input),
        .adc_output(adc_output)
    );
    task testcase001;

    begin
        test_num = 1;
        adc_input = 24'd0;
        $display("Testcase %0d: Input = %d (Expect Output = 0)", test_num, adc_input);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        adc_input = 24'd7;
        $display("Testcase %0d: Input = %d (Expect Output = 0)", test_num, adc_input);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        adc_input = 24'd8;
        $display("Testcase %0d: Input = %d (Expect Output = top 8 bits = 0)", test_num, adc_input);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        adc_input = 24'h00FFFF;
        $display("Testcase %0d: Input = %h (Expect Output = top 8 bits = 0)", test_num, adc_input);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        adc_input = 24'h010000;
        $display("Testcase %0d: Input = %h (Expect Output = top 8 bits = 1)", test_num, adc_input);
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        adc_input = 24'hA5C321;
        $display("Testcase %0d: Input = %h (Expect Output = top 8 bits = A5)", test_num, adc_input);
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        adc_input = 24'hFFFFFF;
        $display("Testcase %0d: Input = %h (Expect Output = top 8 bits = FF)", test_num, adc_input);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_output_processor Testbench");
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
        input [7:0] expected_adc_output;
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
