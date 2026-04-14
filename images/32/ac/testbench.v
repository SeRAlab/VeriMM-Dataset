`timescale 1ns/1ps

module adc_converter_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] adc_input;
    reg enable;
    wire [3:0] lower_half;
    wire [3:0] upper_half;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_converter dut (
        .adc_input(adc_input),
        .enable(enable),
        .lower_half(lower_half),
        .upper_half(upper_half)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: All zeros with enable high", test_num);
            adc_input = 8'h00;
            enable = 1;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: All ones with enable high", test_num);
            adc_input = 8'hFF;
            enable = 1;
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Alternating pattern A5 with enable high", test_num);
            adc_input = 8'hA5;
            enable = 1;
            #1;

            check_outputs(4'h5, 4'hA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Alternating pattern 5A with enable high", test_num);
            adc_input = 8'h5A;
            enable = 1;
            #1;

            check_outputs(4'hA, 4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Upper nibble only with enable high", test_num);
            adc_input = 8'hF0;
            enable = 1;
            #1;

            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Lower nibble only with enable high", test_num);
            adc_input = 8'h0F;
            enable = 1;
            #1;

            check_outputs(4'hF, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTestcase %0d: Input FF with enable low (invalid output)", test_num);
            adc_input = 8'hFF;
            enable = 0;


            #1;



            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTestcase %0d: Random pattern 3C with enable high", test_num);
            adc_input = 8'h3C;
            enable = 1;
            #1;

            check_outputs(4'hC, 4'h3);
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
        input [3:0] expected_lower_half;
        input [3:0] expected_upper_half;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lower_half === (expected_lower_half ^ lower_half ^ expected_lower_half) &&
                expected_upper_half === (expected_upper_half ^ upper_half ^ expected_upper_half)) begin
                $display("PASS");
                $display("  Outputs: lower_half=%h, upper_half=%h",
                         lower_half, upper_half);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lower_half=%h, upper_half=%h",
                         expected_lower_half, expected_upper_half);
                $display("  Got:      lower_half=%h, upper_half=%h",
                         lower_half, upper_half);
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
