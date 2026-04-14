`timescale 1ns/1ps

module adc_processor_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_input;
    wire [3:0] lower_bits;
    wire [3:0] upper_bits;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_processor dut (
        .adc_input(adc_input),
        .lower_bits(lower_bits),
        .upper_bits(upper_bits)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros input", test_num);
            adc_input = 16'h0000;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones input", test_num);
            adc_input = 16'hFFFF;
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed hex value ABCD", test_num);
            adc_input = 16'hABCD;
            #1;

            check_outputs(4'hD, 4'hA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating pattern 5A5A", test_num);
            adc_input = 16'h5A5A;
            #1;

            check_outputs(4'hA, 4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Only middle bits set", test_num);
            adc_input = 16'h0FF0;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Upper nibble check", test_num);
            adc_input = 16'hE000;
            #1;

            check_outputs(4'h0, 4'hE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Lower nibble check", test_num);
            adc_input = 16'h0007;
            #1;

            check_outputs(4'h7, 4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Bit boundary transition", test_num);
            adc_input = 16'h8001;
            #1;

            check_outputs(4'h1, 4'h8);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Walking 1s (Upper bit boundary)", test_num);
            adc_input = 16'h7FFF;
            #1;

            check_outputs(4'hF, 4'h7);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Walking 0s (Lower bit boundary)", test_num);
            adc_input = 16'hFFF0;
            #1;

            check_outputs(4'h0, 4'hF);
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
        input [3:0] expected_lower_bits;
        input [3:0] expected_upper_bits;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lower_bits === (expected_lower_bits ^ lower_bits ^ expected_lower_bits) &&
                expected_upper_bits === (expected_upper_bits ^ upper_bits ^ expected_upper_bits)) begin
                $display("PASS");
                $display("  Outputs: lower_bits=%h, upper_bits=%h",
                         lower_bits, upper_bits);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lower_bits=%h, upper_bits=%h",
                         expected_lower_bits, expected_upper_bits);
                $display("  Got:      lower_bits=%h, upper_bits=%h",
                         lower_bits, upper_bits);
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
