`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] audio_in;
    reg [4:0] threshold;
    wire [4:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .audio_in(audio_in),
        .threshold(threshold),
        .audio_out(audio_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive input below positive threshold", test_num);
            audio_in = 5'd5;
            threshold = 5'd10;
            #1;

            check_outputs(5'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive input above positive threshold", test_num);
            audio_in = 5'd12;
            threshold = 5'd8;
            #1;

            check_outputs(5'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative input with positive threshold", test_num);
            audio_in = -5'sd5;
            threshold = 5'd5;
            #1;

            check_outputs(-5'sd5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive input with negative threshold", test_num);
            audio_in = 5'd3;
            threshold = -5'sd4;
            #1;

            check_outputs(-5'sd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative input above negative threshold", test_num);
            audio_in = -5'sd2;
            threshold = -5'sd6;
            #1;

            check_outputs(-5'sd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative input below negative threshold", test_num);
            audio_in = -5'sd10;
            threshold = -5'sd5;
            #1;

            check_outputs(-5'sd10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input equals threshold (Positive)", test_num);
            audio_in = 5'sd7;
            threshold = 5'sd7;
            #1;

            check_outputs(5'sd7);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input equals threshold (Negative)", test_num);
            audio_in = -5'sd12;
            threshold = -5'sd12;
            #1;

            check_outputs(-5'sd12);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max positive input and max positive threshold", test_num);
            audio_in = 5'sd15;
            threshold = 5'sd15;
            #1;

            check_outputs(5'sd15);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Min negative input and min negative threshold", test_num);
            audio_in = -5'sd16;
            threshold = -5'sd16;
            #1;

            check_outputs(-5'sd16);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input zero with negative threshold", test_num);
            audio_in = 5'sd0;
            threshold = -5'sd1;
            #1;

            check_outputs(-5'sd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dynamic_range_compressor Testbench");
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
        testcase011();
        
        
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
        input [4:0] expected_audio_out;
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
