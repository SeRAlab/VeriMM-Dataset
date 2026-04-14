`timescale 1ns/1ps

module adc_16_to_10_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_input;
    wire [9:0] adc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_16_to_10 dut (
        .adc_input(adc_input),
        .adc_output(adc_output)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Minimum value (0)", test_num);
            adc_input = 16'h0000;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Maximum value (65535)", test_num);
            adc_input = 16'hFFFF;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Midpoint value (32768)", test_num);
            adc_input = 16'h8000;
            #1;

            check_outputs(10'h200);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Boundary - just below 1 (63)", test_num);
            adc_input = 16'h003F;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Boundary - exactly 1 (64)", test_num);
            adc_input = 16'h0040;
            #1;

            check_outputs(10'h001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Quarter scale (16384)", test_num);
            adc_input = 16'h4000;
            #1;

            check_outputs(10'h100);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Three-quarter scale (49152)", test_num);
            adc_input = 16'hC000;
            #1;

            check_outputs(10'h300);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Bit pattern 0xAAAA", test_num);
            adc_input = 16'hAAAA;
            #1;

            check_outputs(10'h2AA);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Bit pattern 0x5555", test_num);
            adc_input = 16'h5555;
            #1;

            check_outputs(10'h155);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Near maximum (65472)", test_num);
            adc_input = 16'hFFC0;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_16_to_10 Testbench");
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
