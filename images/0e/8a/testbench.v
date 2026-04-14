`timescale 1ns/1ps

module adc_8_to_4_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] adc_input;
    wire [3:0] adc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_8_to_4 dut (
        .adc_input(adc_input),
        .adc_output(adc_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum input", test_num);
            adc_input = 8'h00;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum input", test_num);
            adc_input = 8'hFF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Level 0 upper boundary", test_num);
            adc_input = 8'h0F;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Level 1 lower boundary", test_num);
            adc_input = 8'h10;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-point level 7 upper boundary", test_num);
            adc_input = 8'h7F;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-point level 8 lower boundary", test_num);
            adc_input = 8'h80;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 85 (expected level 5)", test_num);
            adc_input = 8'd85;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input 170 (expected level 10)", test_num);
            adc_input = 8'd170;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Level 14 upper boundary", test_num);
            adc_input = 8'hEF;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Level 15 lower boundary", test_num);
            adc_input = 8'hF0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_8_to_4 Testbench");
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
        input [3:0] expected_adc_output;
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
