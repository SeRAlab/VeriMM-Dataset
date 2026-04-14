`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] audio_in1;
    reg [7:0] audio_in2;
    reg [7:0] audio_in3;
    reg [7:0] audio_in4;
    wire [7:0] mixed_audio;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio_in1(audio_in1),
        .audio_in2(audio_in2),
        .audio_in3(audio_in3),
        .audio_in4(audio_in4),
        .mixed_audio(mixed_audio)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros", test_num);
        audio_in1 = 8'd0;
        audio_in2 = 8'd0;
        audio_in3 = 8'd0;
        audio_in4 = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Max (255)", test_num);
        audio_in1 = 8'd255;
        audio_in2 = 8'd255;
        audio_in3 = 8'd255;
        audio_in4 = 8'd255;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Uniform Mid-range (128)", test_num);
        audio_in1 = 8'd128;
        audio_in2 = 8'd128;
        audio_in3 = 8'd128;
        audio_in4 = 8'd128;
        #1;

        check_outputs(8'd128);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Even Average (10, 20, 30, 40)", test_num);
        audio_in1 = 8'd10;
        audio_in2 = 8'd20;
        audio_in3 = 8'd30;
        audio_in4 = 8'd40;
        #1;

        check_outputs(8'd25);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Truncation Down (3, 0, 0, 0)", test_num);
        audio_in1 = 8'd3;
        audio_in2 = 8'd0;
        audio_in3 = 8'd0;
        audio_in4 = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Truncation Down (7, 0, 0, 0)", test_num);
        audio_in1 = 8'd7;
        audio_in2 = 8'd0;
        audio_in3 = 8'd0;
        audio_in4 = 8'd0;
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Extreme Mix (255, 0, 255, 0)", test_num);
        audio_in1 = 8'd255;
        audio_in2 = 8'd0;
        audio_in3 = 8'd255;
        audio_in4 = 8'd0;
        #1;

        check_outputs(8'd127);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: High Range Average (200, 210, 220, 230)", test_num);
        audio_in1 = 8'd200;
        audio_in2 = 8'd210;
        audio_in3 = 8'd220;
        audio_in4 = 8'd230;
        #1;

        check_outputs(8'd215);
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
