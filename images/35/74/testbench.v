`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] audio_sample1;
    reg [7:0] audio_sample2;
    wire [7:0] mixed_audio;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio_sample1(audio_sample1),
        .audio_sample2(audio_sample2),
        .mixed_audio(mixed_audio)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Zero inputs", test_num);
        audio_sample1 = 8'd0;
        audio_sample2 = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Maximum inputs", test_num);
        audio_sample1 = 8'd255;
        audio_sample2 = 8'd255;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Simple even sum", test_num);
        audio_sample1 = 8'd10;
        audio_sample2 = 8'd20;
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Odd sum rounding up (10, 11)", test_num);
        audio_sample1 = 8'd10;
        audio_sample2 = 8'd11;
        #1;

        check_outputs(8'd11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Boundary rounding (0, 1)", test_num);
        audio_sample1 = 8'd0;
        audio_sample2 = 8'd1;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Mid-range rounding (127, 128)", test_num);
        audio_sample1 = 8'd127;
        audio_sample2 = 8'd128;
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: High-range rounding (254, 255)", test_num);
        audio_sample1 = 8'd254;
        audio_sample2 = 8'd255;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Maximum spread (0, 255)", test_num);
        audio_sample1 = 8'd0;
        audio_sample2 = 8'd255;
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Symmetric inputs (128, 128)", test_num);
        audio_sample1 = 8'd128;
        audio_sample2 = 8'd128;
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Typical values (64, 192)", test_num);
        audio_sample1 = 8'd64;
        audio_sample2 = 8'd192;
        #1;

        check_outputs(8'd128);
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
        input [7:0] expected_mixed_audio;
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
