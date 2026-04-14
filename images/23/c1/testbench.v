`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] audio_in1;
    reg [4:0] audio_in2;
    wire [4:0] mixed_audio;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio_in1(audio_in1),
        .audio_in2(audio_in2),
        .mixed_audio(mixed_audio)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            audio_in1 = 5'b00000;
            audio_in2 = 5'b00000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones", test_num);
            audio_in1 = 5'b11111;
            audio_in2 = 5'b11111;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: No Bit Overlap", test_num);
            audio_in1 = 5'b10101;
            audio_in2 = 5'b01010;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Identity (AND with 1s)", test_num);
            audio_in1 = 5'b10110;
            audio_in2 = 5'b11111;
            #1;

            check_outputs(5'b10110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Nullification (AND with 0s)", test_num);
            audio_in1 = 5'b11111;
            audio_in2 = 5'b00000;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Partial Overlap", test_num);
            audio_in1 = 5'b11000;
            audio_in2 = 5'b10001;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random Bit Pattern", test_num);
            audio_in1 = 5'b01101;
            audio_in2 = 5'b00111;

            #1;


            check_outputs(5'b00101);
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
