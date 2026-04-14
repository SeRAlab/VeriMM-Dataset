`timescale 1ns/1ps

module adc_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_value1;
    reg [23:0] adc_value2;
    wire greater_than;
    wire [1:0] status;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_comparator dut (
        .adc_value1(adc_value1),
        .adc_value2(adc_value2),
        .greater_than(greater_than),
        .status(status)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Equal values (Zero)", test_num);
            adc_value1 = 24'h000000;
            adc_value2 = 24'h000000;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Equal values (Max)", test_num);
            adc_value1 = 24'hFFFFFF;
            adc_value2 = 24'hFFFFFF;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Equal values (Mid-range)", test_num);
            adc_value1 = 24'h123456;
            adc_value2 = 24'h123456;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: First input greater (Small difference)", test_num);
            adc_value1 = 24'h000001;
            adc_value2 = 24'h000000;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Second input greater (Small difference)", test_num);
            adc_value1 = 24'h000000;
            adc_value2 = 24'h000001;
            #1;

            check_outputs(1'b0, 2'b10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: First input greater (Max vs Min)", test_num);
            adc_value1 = 24'hFFFFFF;
            adc_value2 = 24'h000000;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Second input greater (Min vs Max)", test_num);
            adc_value1 = 24'h000000;
            adc_value2 = 24'hFFFFFF;
            #1;

            check_outputs(1'b0, 2'b10);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: First input greater (MSB difference)", test_num);
            adc_value1 = 24'h800000;
            adc_value2 = 24'h7FFFFF;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Second input greater (MSB difference)", test_num);
            adc_value1 = 24'h7FFFFF;
            adc_value2 = 24'h800000;
            #1;

            check_outputs(1'b0, 2'b10);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Complex comparison (Alternating bits)", test_num);
            adc_value1 = 24'hAAAAAA;
            adc_value2 = 24'h555555;
            #1;

            check_outputs(1'b1, 2'b01);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_comparator Testbench");
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
        input expected_greater_than;
        input [1:0] expected_status;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_greater_than === (expected_greater_than ^ greater_than ^ expected_greater_than) &&
                expected_status === (expected_status ^ status ^ expected_status)) begin
                $display("PASS");
                $display("  Outputs: greater_than=%b, status=%h",
                         greater_than, status);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: greater_than=%b, status=%h",
                         expected_greater_than, expected_status);
                $display("  Got:      greater_than=%b, status=%h",
                         greater_than, status);
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
