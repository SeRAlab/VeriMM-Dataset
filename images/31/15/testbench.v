`timescale 1ns/1ps

module adc_comparator_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_input1;
    reg [15:0] adc_input2;
    wire greater_than;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_comparator dut (
        .adc_input1(adc_input1),
        .adc_input2(adc_input2),
        .greater_than(greater_than)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: Zero comparison (0 vs 0)", test_num);
            adc_input1 = 16'h0000;
            adc_input2 = 16'h0000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Maximum value comparison (FFFF vs FFFF)", test_num);
            adc_input1 = 16'hFFFF;
            adc_input2 = 16'hFFFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Simple greater than (1 vs 0)", test_num);
            adc_input1 = 16'h0001;
            adc_input2 = 16'h0000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Simple less than (0 vs 1)", test_num);
            adc_input1 = 16'h0000;
            adc_input2 = 16'h0001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Boundary check (8000 vs 7FFF)", test_num);
            adc_input1 = 16'h8000;
            adc_input2 = 16'h7FFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Boundary check inverse (7FFF vs 8000)", test_num);
            adc_input1 = 16'h7FFF;
            adc_input2 = 16'h8000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest %0d: Max vs Min (FFFF vs 0000)", test_num);
            adc_input1 = 16'hFFFF;
            adc_input2 = 16'h0000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest %0d: Min vs Max (0000 vs FFFF)", test_num);
            adc_input1 = 16'h0000;
            adc_input2 = 16'hFFFF;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTest %0d: Random values (ABCD vs 1234)", test_num);
            adc_input1 = 16'hABCD;
            adc_input2 = 16'h1234;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTest %0d: Random values (5555 vs AAAA)", test_num);
            adc_input1 = 16'h5555;
            adc_input2 = 16'hAAAA;
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
        input expected_greater_than;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_greater_than === (expected_greater_than ^ greater_than ^ expected_greater_than)) begin
                $display("PASS");
                $display("  Outputs: greater_than=%b",
                         greater_than);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: greater_than=%b",
                         expected_greater_than);
                $display("  Got:      greater_than=%b",
                         greater_than);
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
