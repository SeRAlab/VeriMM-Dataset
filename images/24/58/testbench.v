`timescale 1ns/1ps

module adc_24_to_32_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] adc_in;
    wire [31:0] adc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_24_to_32 dut (
        .adc_in(adc_in),
        .adc_out(adc_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Zeros", test_num);
            adc_in = 24'h000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Ones", test_num);
            adc_in = 24'hFFFFFF;
            #1;

            check_outputs(32'hFFFFFF00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits Pattern A", test_num);
            adc_in = 24'hAAAAAA;
            #1;

            check_outputs(32'hAAAAAA00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits Pattern 5", test_num);
            adc_in = 24'h555555;
            #1;

            check_outputs(32'h55555500);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: MSB Set Only", test_num);
            adc_in = 24'h800000;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: LSB Set Only", test_num);
            adc_in = 24'h000001;
            #1;

            check_outputs(32'h00000100);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Arbitrary Hex Value ABCDEF", test_num);
            adc_in = 24'hABCDEF;
            #1;

            check_outputs(32'hABCDEF00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Arbitrary Hex Value 123456", test_num);
            adc_in = 24'h123456;
            #1;

            check_outputs(32'h12345600);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_24_to_32 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [31:0] expected_adc_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adc_out === (expected_adc_out ^ adc_out ^ expected_adc_out)) begin
                $display("PASS");
                $display("  Outputs: adc_out=%h",
                         adc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adc_out=%h",
                         expected_adc_out);
                $display("  Got:      adc_out=%h",
                         adc_out);
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
