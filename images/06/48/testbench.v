`timescale 1ns/1ps

module audio_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] audio_sample;
    wire [3:0] compressed_audio;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_compressor dut (
        .audio_sample(audio_sample),
        .compressed_audio(compressed_audio)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum value (0)", test_num);
            audio_sample = 5'b00000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum value (31)", test_num);
            audio_sample = 5'b11111;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Odd value dropping LSB (1)", test_num);
            audio_sample = 5'b00001;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Even value shifting (2)", test_num);
            audio_sample = 5'b00010;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range value (10)", test_num);
            audio_sample = 5'd10;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range value (11)", test_num);
            audio_sample = 5'd11;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating pattern (21)", test_num);
            audio_sample = 5'b10101;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of two (16)", test_num);
            audio_sample = 5'b10000;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_compressor Testbench");
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
        input [3:0] expected_compressed_audio;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_compressed_audio === (expected_compressed_audio ^ compressed_audio ^ expected_compressed_audio)) begin
                $display("PASS");
                $display("  Outputs: compressed_audio=%h",
                         compressed_audio);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: compressed_audio=%h",
                         expected_compressed_audio);
                $display("  Got:      compressed_audio=%h",
                         compressed_audio);
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
