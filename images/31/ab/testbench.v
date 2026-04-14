`timescale 1ns/1ps

module qam_modulator_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] amplitude;
    reg [1:0] phase;
    wire [5:0] qam_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qam_modulator dut (
        .amplitude(amplitude),
        .phase(phase),
        .qam_signal(qam_signal)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum Amplitude, Phase 00", test_num);
            amplitude = 4'b0000;
            phase = 2'b00;
            #1;

            check_outputs(6'b0000_00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum Amplitude, Phase 01", test_num);
            amplitude = 4'b0000;
            phase = 2'b01;
            #1;

            check_outputs(6'b0000_01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum Amplitude, Phase 10", test_num);
            amplitude = 4'b0000;
            phase = 2'b10;
            #1;

            check_outputs(6'b0000_10);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum Amplitude, Phase 11", test_num);
            amplitude = 4'b0000;
            phase = 2'b11;
            #1;

            check_outputs(6'b0000_11);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Amplitude, Phase 00", test_num);
            amplitude = 4'b1111;
            phase = 2'b00;
            #1;

            check_outputs(6'b1111_00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Amplitude, Phase 11", test_num);
            amplitude = 4'b1111;
            phase = 2'b11;
            #1;

            check_outputs(6'b1111_11);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Intermediate Amplitude 1010, Phase 01", test_num);
            amplitude = 4'b1010;
            phase = 2'b01;
            #1;

            check_outputs(6'b1010_01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Intermediate Amplitude 0101, Phase 10", test_num);
            amplitude = 4'b0101;
            phase = 2'b10;
            #1;

            check_outputs(6'b0101_10);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Amplitude 1000, Phase 11", test_num);
            amplitude = 4'b1000;
            phase = 2'b11;
            #1;

            check_outputs(6'b1000_11);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Amplitude 0001, Phase 00", test_num);
            amplitude = 4'b0001;
            phase = 2'b00;
            #1;

            check_outputs(6'b0001_00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qam_modulator Testbench");
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
        input [5:0] expected_qam_signal;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_qam_signal === (expected_qam_signal ^ qam_signal ^ expected_qam_signal)) begin
                $display("PASS");
                $display("  Outputs: qam_signal=%h",
                         qam_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: qam_signal=%h",
                         expected_qam_signal);
                $display("  Got:      qam_signal=%h",
                         qam_signal);
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
