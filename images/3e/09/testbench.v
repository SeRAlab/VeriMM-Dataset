`timescale 1ns/1ps

module DAC_Controller_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] channel_select;
    reg [15:0] data_input;
    wire [15:0] dac_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DAC_Controller dut (
        .channel_select(channel_select),
        .data_input(data_input),
        .dac_output(dac_output)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Channel 0, Min Data", test_num);
            channel_select = 4'h0;
            data_input = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Channel 15, Max Data", test_num);
            channel_select = 4'hF;
            data_input = 16'hFFFF;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-range Channel, Alternating Pattern", test_num);
            channel_select = 4'h7;
            data_input = 16'hAAAA;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-range Channel, Inverse Alternating Pattern", test_num);
            channel_select = 4'h8;
            data_input = 16'h5555;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Random Channel and Data", test_num);
            channel_select = 4'hC;
            data_input = 16'h1234;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Rapid Data Change on Single Channel", test_num);
            channel_select = 4'h3;
            data_input = 16'hBEEF;
            #5;
            data_input = 16'hDEAD;
            #1;

            check_outputs(16'hDEAD);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Walking Bit Data Pattern", test_num);
            channel_select = 4'hA;
            data_input = 16'h0001;
            #2;
            data_input = 16'h0002;
            #2;
            data_input = 16'h0004;
            #2;
            data_input = 16'h0008;
            #1;

            check_outputs(16'h0008);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DAC_Controller Testbench");
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
        input [15:0] expected_dac_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dac_output === (expected_dac_output ^ dac_output ^ expected_dac_output)) begin
                $display("PASS");
                $display("  Outputs: dac_output=%h",
                         dac_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dac_output=%h",
                         expected_dac_output);
                $display("  Got:      dac_output=%h",
                         dac_output);
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
