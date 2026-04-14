`timescale 1ns/1ps

module adc_processor_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_input;
    wire [7:0] msb_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_processor dut (
        .adc_input(adc_input),
        .msb_output(msb_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: All zeros input", test_num);
            adc_input = 16'h0000;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: All ones input", test_num);
            adc_input = 16'hFFFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Typical value check", test_num);
            adc_input = 16'h1234;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Hex value with high MSB", test_num);
            adc_input = 16'hABCD;
            #1;

            check_outputs(8'hAB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Changing only LSBs (verify no change in MSB)", test_num);
            adc_input = 16'h7F01;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Max LSBs with zero MSBs", test_num);
            adc_input = 16'h00FF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Alternating bits pattern 1", test_num);
            adc_input = 16'hAAAA;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Alternating bits pattern 2", test_num);
            adc_input = 16'h5555;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Single bit set at MSB boundary", test_num);
            adc_input = 16'h8000;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Single bit set at output LSB", test_num);
            adc_input = 16'h0100;
            #1;

            check_outputs(8'h01);
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
        input [7:0] expected_msb_output;
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
