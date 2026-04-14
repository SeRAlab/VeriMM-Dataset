`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] audio1;
    reg [7:0] audio2;
    reg mute;
    wire [7:0] output_audio;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio1(audio1),
        .audio2(audio2),
        .mute(mute),
        .output_audio(output_audio)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mute enabled - Output should be zero", test_num);
            audio1 = 8'h12;
            audio2 = 8'h34;
            mute = 1'b1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic addition - No overflow", test_num);
            audio1 = 8'h10;
            audio2 = 8'h20;
            mute = 1'b0;
            #1;

            check_outputs(8'h30);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow addition - 0xFF + 0x01 = 0x00", test_num);
            audio1 = 8'hFF;
            audio2 = 8'h01;
            mute = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow addition - 0x80 + 0x80 = 0x00", test_num);
            audio1 = 8'h80;
            audio2 = 8'h80;
            mute = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum wrap around - 0xFF + 0xFF = 0xFE", test_num);
            audio1 = 8'hFF;
            audio2 = 8'hFF;
            mute = 1'b0;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero inputs addition", test_num);
            audio1 = 8'h00;
            audio2 = 8'h00;
            mute = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mute override during overflow potential", test_num);
            audio1 = 8'hFF;
            audio2 = 8'hFF;
            mute = 1'b1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-range addition", test_num);
            audio1 = 8'h7F;
            audio2 = 8'h01;
            mute = 1'b0;
            #1;

            check_outputs(8'h80);
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
        input [7:0] expected_output_audio;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_output_audio === (expected_output_audio ^ output_audio ^ expected_output_audio)) begin
                $display("PASS");
                $display("  Outputs: output_audio=%h",
                         output_audio);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: output_audio=%h",
                         expected_output_audio);
                $display("  Got:      output_audio=%h",
                         output_audio);
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
