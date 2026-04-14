`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] audio_in1;
    reg [3:0] audio_in2;
    wire [3:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio_in1(audio_in1),
        .audio_in2(audio_in2),
        .audio_out(audio_out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Both inputs are zero", test_num);
            audio_in1 = 4'd0;
            audio_in2 = 4'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Both inputs are maximum value (15)", test_num);
            audio_in1 = 4'd15;
            audio_in2 = 4'd15;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Equal even values", test_num);
            audio_in1 = 4'd8;
            audio_in2 = 4'd8;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Equal odd values", test_num);
            audio_in1 = 4'd7;
            audio_in2 = 4'd7;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Odd sum (rounding down check - 3.5 to 3)", test_num);
            audio_in1 = 4'd3;
            audio_in2 = 4'd4;
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Odd sum (rounding down check - 14.5 to 14)", test_num);
            audio_in1 = 4'd14;
            audio_in2 = 4'd15;
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: One zero and one max value", test_num);
            audio_in1 = 4'd0;
            audio_in2 = 4'd15;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Mix of small and large value", test_num);
            audio_in1 = 4'd2;
            audio_in2 = 4'd12;
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Minimum difference odd sum", test_num);
            audio_in1 = 4'd0;
            audio_in2 = 4'd1;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: General case", test_num);
            audio_in1 = 4'd10;
            audio_in2 = 4'd5;
            #1;

            check_outputs(4'd7);
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
        input [3:0] expected_audio_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_audio_out === (expected_audio_out ^ audio_out ^ expected_audio_out)) begin
                $display("PASS");
                $display("  Outputs: audio_out=%h",
                         audio_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: audio_out=%h",
                         expected_audio_out);
                $display("  Got:      audio_out=%h",
                         audio_out);
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
