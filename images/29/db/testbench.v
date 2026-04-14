`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] audio1;
    reg [4:0] audio2;
    wire [4:0] mixed_audio;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio1(audio1),
        .audio2(audio2),
        .mixed_audio(mixed_audio)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeroes", test_num);
            audio1 = 5'd0;
            audio2 = 5'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Values", test_num);
            audio1 = 5'd31;
            audio2 = 5'd31;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identical Mid-range", test_num);
            audio1 = 5'd15;
            audio2 = 5'd15;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Odd Sum Round Down (0 and 31)", test_num);
            audio1 = 5'd0;
            audio2 = 5'd31;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Odd Sum Round Down (10 and 11)", test_num);
            audio1 = 5'd10;
            audio2 = 5'd11;
            #1;

            check_outputs(5'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Symmetry Check", test_num);
            audio1 = 5'd20;
            audio2 = 5'd4;
            #1;

            check_outputs(5'd12);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Smallest Odd Sum", test_num);
            audio1 = 5'd0;
            audio2 = 5'd1;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High Range Round Down", test_num);
            audio1 = 5'd30;
            audio2 = 5'd31;
            #1;

            check_outputs(5'd30);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_mixer Testbench");
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
        input [4:0] expected_mixed_audio;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mixed_audio === (expected_mixed_audio ^ mixed_audio ^ expected_mixed_audio)) begin
                $display("PASS");
                $display("  Outputs: mixed_audio=%h",
                         mixed_audio);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mixed_audio=%h",
                         expected_mixed_audio);
                $display("  Got:      mixed_audio=%h",
                         mixed_audio);
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
