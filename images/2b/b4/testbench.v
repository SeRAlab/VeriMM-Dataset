`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] audio_in1;
    reg [15:0] audio_in2;
    reg sel;
    wire [15:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio_in1(audio_in1),
        .audio_in2(audio_in2),
        .sel(sel),
        .audio_out(audio_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input 1 (Input 2 is Idle)", test_num);
            audio_in1 = 16'h1234;
            audio_in2 = 16'h0000;
            sel = 0;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input 2 (Input 1 is Idle)", test_num);
            audio_in1 = 16'h0000;
            audio_in2 = 16'hABCD;
            sel = 1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mix Mode (Both Present) - Control sel=0", test_num);
            audio_in1 = 16'h1000;
            audio_in2 = 16'h3000;
            sel = 0;

            #1;


            check_outputs(16'h2000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mix Mode (Both Present) - Control sel=1", test_num);
            audio_in1 = 16'h4000;
            audio_in2 = 16'h2000;
            sel = 1;

            #1;


            check_outputs(16'h3000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge Case - Maximum Values Averaging", test_num);
            audio_in1 = 16'hFFFF;
            audio_in2 = 16'hFFFF;
            sel = 0;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Edge Case - Large Sum Averaging", test_num);
            audio_in1 = 16'hFFFF;
            audio_in2 = 16'h0001;
            sel = 1;

            #1;


            check_outputs(16'h8000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No Signals Present", test_num);
            audio_in1 = 16'h0000;
            audio_in2 = 16'h0000;
            sel = 0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Idle Input (Mux Logic)", test_num);
            audio_in1 = 16'hAAAA;
            audio_in2 = 16'h0000;
            sel = 1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Truncation Check (Odd Sum)", test_num);
            audio_in1 = 16'h0002;
            audio_in2 = 16'h0003;
            sel = 0;

            #1;


            check_outputs(16'h0002);
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
        input [15:0] expected_audio_out;
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
