`timescale 1ns/1ps

module adc_decoder_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_input;
    wire [31:0] decimal_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_decoder dut (
        .adc_input(adc_input),
        .decimal_output(decimal_output)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum Value (Zero)", test_num);
        adc_input = 24'h000000;
        #10;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small Value", test_num);
        adc_input = 24'd1024;
        #10;
        #1;

        check_outputs(32'd1024);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-range Value", test_num);
        adc_input = 24'h7FFFFF;
        #10;
        #1;

        check_outputs(32'h007FFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random Bit Pattern", test_num);
        adc_input = 24'hA5A5A5;
        #10;
        #1;

        check_outputs(32'h00A5A5A5);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum 24-bit Value", test_num);

        adc_input = 24'hFFFFFF;
        #10;



        #1;




        check_outputs(32'h00FFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Another Arbitrary Value", test_num);
        adc_input = 24'd1234567;
        #10;
        #1;

        check_outputs(32'd1234567);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_decoder Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [31:0] expected_decimal_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decimal_output === (expected_decimal_output ^ decimal_output ^ expected_decimal_output)) begin
                $display("PASS");
                $display("  Outputs: decimal_output=%h",
                         decimal_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decimal_output=%h",
                         expected_decimal_output);
                $display("  Got:      decimal_output=%h",
                         decimal_output);
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
