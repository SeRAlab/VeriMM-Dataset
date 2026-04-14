`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] audio_signal;
    reg [15:0] echo_signal;
    wire [15:0] output_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancellation dut (
        .audio_signal(audio_signal),
        .echo_signal(echo_signal),
        .output_signal(output_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero inputs - expecting zero output", test_num);
            audio_signal = 16'h0000;
            echo_signal = 16'h0000;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Perfect cancellation (audio == echo)", test_num);
            audio_signal = 16'hABCD;
            echo_signal  = 16'hABCD;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No echo (echo == 0)", test_num);
            audio_signal = 16'h55AA;
            echo_signal  = 16'h0000;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Standard echo reduction (audio > echo)", test_num);
            audio_signal = 16'd10000;
            echo_signal  = 16'd2500;
            #1;

            check_outputs(16'd7500);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large echo (audio < echo, checking wrap-around)", test_num);
            audio_signal = 16'd1000;
            echo_signal  = 16'd3000;

            #1;


            check_outputs(16'hF830);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum audio signal boundary", test_num);
            audio_signal = 16'hFFFF;
            echo_signal  = 16'h0001;
            #1;

            check_outputs(16'hFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max positive signed value cancellation", test_num);
            audio_signal = 16'h7FFF;
            echo_signal  = 16'h7FFF;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Very small signal difference", test_num);
            audio_signal = 16'h0005;
            echo_signal  = 16'h0002;
            #1;

            check_outputs(16'h0003);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("echo_cancellation Testbench");
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
        input [15:0] expected_output_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_signal === (expected_output_signal ^ output_signal ^ expected_output_signal)) begin
                $display("PASS");
                $display("  Outputs: output_signal=%h",
                         output_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_signal=%h",
                         expected_output_signal);
                $display("  Got:      output_signal=%h",
                         output_signal);
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
