`timescale 1ns/1ps

module adc_converter_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] adc_input;
    wire [15:0] adc_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_converter dut (
        .adc_input(adc_input),
        .adc_output(adc_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Minimum input (0x000)", test_num);
        adc_input = 12'h000;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum input (0xFFF)", test_num);
        adc_input = 12'hFFF;
        #1;

        check_outputs(16'hFFF0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid-scale input (0x800)", test_num);
        adc_input = 12'h800;
        #1;

        check_outputs(16'h8000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Step input (0x001)", test_num);
        adc_input = 12'h001;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern 0xAAA", test_num);
        adc_input = 12'hAAA;
        #1;

        check_outputs(16'hAAA0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Pattern 0x555", test_num);
        adc_input = 12'h555;
        #1;

        check_outputs(16'h5550);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Arbitrary input (0xC81)", test_num);
        adc_input = 12'hC81;
        #1;

        check_outputs(16'hC810);
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
        input [15:0] expected_adc_output;
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
