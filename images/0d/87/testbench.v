`timescale 1ns/1ps

module adc_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_value;
    wire [7:0] encoded_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_encoder dut (
        .adc_value(adc_value),
        .encoded_value(encoded_value)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Range 1 - Minimum Value (0)", test_num);
            adc_value = 16'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Range 1 - Intermediate Value (127)", test_num);
            adc_value = 16'd127;
            #1;

            check_outputs(8'd127);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Range 1 - Maximum Value (255)", test_num);
            adc_value = 16'd255;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Range 2 - Minimum Value (256)", test_num);
            adc_value = 16'd256;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Range 2 - Intermediate Value (400)", test_num);
            adc_value = 16'd400;
            #1;

            check_outputs(8'd144);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Range 2 - Maximum Value (511)", test_num);
            adc_value = 16'd511;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Range 3 - Boundary Value (512)", test_num);
            adc_value = 16'd512;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Range 3 - High Value (1000)", test_num);
            adc_value = 16'd1000;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Range 3 - Maximum 16-bit Input (65535)", test_num);
            adc_value = 16'hFFFF;
            #1;

            check_outputs(8'd255);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_encoder Testbench");
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
        input [7:0] expected_encoded_value;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded_value === (expected_encoded_value ^ encoded_value ^ expected_encoded_value)) begin
                $display("PASS");
                $display("  Outputs: encoded_value=%h",
                         encoded_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded_value=%h",
                         expected_encoded_value);
                $display("  Got:      encoded_value=%h",
                         encoded_value);
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
