`timescale 1ns/1ps

module adc_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_value1;
    reg [15:0] adc_value2;
    wire greater;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_comparator dut (
        .adc_value1(adc_value1),
        .adc_value2(adc_value2),
        .greater(greater)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple Greater Than Comparison", test_num);
        adc_value1 = 16'd1000;
        adc_value2 = 16'd500;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple Less Than Comparison", test_num);
        adc_value1 = 16'd200;
        adc_value2 = 16'd800;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Equal Values Comparison", test_num);
        adc_value1 = 16'd5555;
        adc_value2 = 16'd5555;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary - Zero vs Zero", test_num);
        adc_value1 = 16'h0000;
        adc_value2 = 16'h0000;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary - Max vs Max", test_num);
        adc_value1 = 16'hFFFF;
        adc_value2 = 16'hFFFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary - Max vs Min", test_num);
        adc_value1 = 16'hFFFF;
        adc_value2 = 16'h0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Boundary - Min vs Max", test_num);
        adc_value1 = 16'h0000;
        adc_value2 = 16'hFFFF;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Difference at MSB", test_num);
        adc_value1 = 16'h8000;
        adc_value2 = 16'h7FFF;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Difference at LSB (Greater)", test_num);
        adc_value1 = 16'h0002;
        adc_value2 = 16'h0001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Difference at LSB (Less)", test_num);
        adc_value1 = 16'hFFFE;
        adc_value2 = 16'hFFFF;
        #1;

        check_outputs(1'b0);
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
        input expected_greater;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_greater === (expected_greater ^ greater ^ expected_greater)) begin
                $display("PASS");
                $display("  Outputs: greater=%b",
                         greater);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: greater=%b",
                         expected_greater);
                $display("  Got:      greater=%b",
                         greater);
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
