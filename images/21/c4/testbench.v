`timescale 1ns/1ps

module adc_controller_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_input;
    wire [23:0] adc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_controller dut (
        .adc_input(adc_input),
        .adc_output(adc_output)
    );
    task testcase001;

        begin
            test_num = 1;
            adc_input = 24'h000000;
            $display("Test %0d: Input = %h (Zero Check)", test_num, adc_input);
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            adc_input = 24'hFFFFFF;
            $display("Test %0d: Input = %h (Max Value Check)", test_num, adc_input);

            #1;


            check_outputs(24'h00FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            adc_input = 24'h123456;
            $display("Test %0d: Input = %h (Standard Pattern)", test_num, adc_input);

            #1;


            check_outputs(24'h001234);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            adc_input = 24'h0000FF;
            $display("Test %0d: Input = %h (LSB Truncation Check)", test_num, adc_input);

            #1;


            check_outputs(24'h000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            adc_input = 24'h00FF00;
            $display("Test %0d: Input = %h (Middle Bits Shift)", test_num, adc_input);

            #1;


            check_outputs(24'h0000FF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            adc_input = 24'hFF0000;
            $display("Test %0d: Input = %h (High Bits Shift)", test_num, adc_input);

            #1;


            check_outputs(24'h00FF00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            adc_input = 24'hAAAAAA;
            $display("Test %0d: Input = %h (Alternating Bit Pattern)", test_num, adc_input);

            #1;


            check_outputs(24'h00AAAA);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            adc_input = 24'h000100;
            $display("Test %0d: Input = %h (Boundary Bit Shift)", test_num, adc_input);

            #1;


            check_outputs(24'h000001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_controller Testbench");
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
        input [23:0] expected_adc_output;
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
