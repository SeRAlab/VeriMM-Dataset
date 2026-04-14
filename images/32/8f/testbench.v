`timescale 1ns/1ps

module adc_4to8_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary_in;
    wire [7:0] adc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adc_4to8 dut (
        .binary_in(binary_in),
        .adc_out(adc_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum value (0)", test_num);
            binary_in = 4'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 1", test_num);
            binary_in = 4'd1;
            #1;

            check_outputs(8'd16);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 2", test_num);
            binary_in = 4'd2;
            #1;

            check_outputs(8'd32);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-point lower (7)", test_num);
            binary_in = 4'd7;
            #1;

            check_outputs(8'd112);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-point upper (8)", test_num);
            binary_in = 4'd8;
            #1;

            check_outputs(8'd128);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 10", test_num);
            binary_in = 4'd10;
            #1;

            check_outputs(8'd160);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Input 14", test_num);
            binary_in = 4'd14;
            #1;

            check_outputs(8'd224);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum value (15)", test_num);
            binary_in = 4'd15;
            #1;

            check_outputs(8'd240);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adc_4to8 Testbench");
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
        input [7:0] expected_adc_out;
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
