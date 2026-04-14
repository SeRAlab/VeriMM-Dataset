`timescale 1ns/1ps

module adc_msn_extractor_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] adc_input;
    wire [3:0] msn_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_msn_extractor dut (
        .adc_input(adc_input),
        .msn_output(msn_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: All Zeros", test_num);
        adc_input = 16'h0000;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: All Ones", test_num);
        adc_input = 16'hFFFF;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: MSN 1 with lower bits set", test_num);
        adc_input = 16'h1FFF;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: MSN 8 with lower bits zero", test_num);
        adc_input = 16'h8000;
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Pattern A5A5", test_num);
        adc_input = 16'hA5A5;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Pattern 5A5A", test_num);
        adc_input = 16'h5A5A;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: MSN E with mixed lower bits", test_num);
        adc_input = 16'hE248;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: MSN 3 with lower bits at max", test_num);
        adc_input = 16'h3FFF;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Minimum value (0x0001)", test_num);
        adc_input = 16'h0001;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: High MSN nibble (0xCDEF)", test_num);
        adc_input = 16'hCDEF;
        #1;

        check_outputs(4'hC);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_msn_extractor Testbench");
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
        input [3:0] expected_msn_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_msn_output === (expected_msn_output ^ msn_output ^ expected_msn_output)) begin
                $display("PASS");
                $display("  Outputs: msn_output=%h",
                         msn_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: msn_output=%h",
                         expected_msn_output);
                $display("  Got:      msn_output=%h",
                         msn_output);
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
