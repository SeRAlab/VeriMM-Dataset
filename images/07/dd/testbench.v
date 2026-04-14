`timescale 1ns/1ps

module adc_msb_processor_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_input;
    wire [3:0] msb_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_msb_processor dut (
        .adc_input(adc_input),
        .msb_output(msb_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (0x0000)", test_num);
            adc_input = 16'h0000;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones (0xFFFF)", test_num);
            adc_input = 16'hFFFF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit 15 set (0x8000)", test_num);
            adc_input = 16'h8000;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB Nibble only (0xF000)", test_num);
            adc_input = 16'hF000;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper boundary of 0x0 (0x0FFF)", test_num);
            adc_input = 16'h0FFF;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Lower boundary of 0x1 (0x1000)", test_num);
            adc_input = 16'h1000;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits A (0xAAAA)", test_num);
            adc_input = 16'hAAAA;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 5 (0x5555)", test_num);
            adc_input = 16'h5555;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Value (0x1234)", test_num);
            adc_input = 16'h1234;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Value (0xABCD)", test_num);
            adc_input = 16'hABCD;
            #1;

            check_outputs(4'hA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_msb_processor Testbench");
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
        input [3:0] expected_msb_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_msb_output === (expected_msb_output ^ msb_output ^ expected_msb_output)) begin
                $display("PASS");
                $display("  Outputs: msb_output=%h",
                         msb_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: msb_output=%h",
                         expected_msb_output);
                $display("  Got:      msb_output=%h",
                         msb_output);
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
