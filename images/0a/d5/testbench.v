`timescale 1ns/1ps

module adc_to_gray_converter_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] binary_input;
    wire [23:0] gray_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_to_gray_converter dut (
        .binary_input(binary_input),
        .gray_output(gray_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input 0", test_num);
            binary_input = 24'h000000;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input 1", test_num);
            binary_input = 24'h000001;
            #1;

            check_outputs(24'h000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones (Max Value)", test_num);
            binary_input = 24'hFFFFFF;
            #1;

            check_outputs(24'h800000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Most Significant Bit High", test_num);
            binary_input = 24'h800000;
            #1;

            check_outputs(24'hC00000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits (AAAAAA)", test_num);
            binary_input = 24'hAAAAAA;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits (555555)", test_num);
            binary_input = 24'h555555;
            #1;

            check_outputs(24'h7FFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Value crossing power of 2 (Input 7 to 8)", test_num);

            binary_input = 24'd7;
            #1;

            binary_input = 24'd8;
            #1;

            check_outputs(24'h00000C);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random pattern 123456", test_num);
            binary_input = 24'h123456;
            #1;

            check_outputs(24'h1B1663);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random pattern ABCDEF", test_num);
            binary_input = 24'hABCDEF;
            #1;

            check_outputs(24'hF1E697);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit flip check (input 0 to 1)", test_num);
            binary_input = 24'h000000;
            #1;
            binary_input = 24'h000001;
            #1;

            check_outputs(24'h000001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_to_gray_converter Testbench");
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
        input [23:0] expected_gray_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gray_output === (expected_gray_output ^ gray_output ^ expected_gray_output)) begin
                $display("PASS");
                $display("  Outputs: gray_output=%h",
                         gray_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_output=%h",
                         expected_gray_output);
                $display("  Got:      gray_output=%h",
                         gray_output);
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
