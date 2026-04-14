`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] audio1;
    reg [7:0] audio2;
    reg [7:0] audio3;
    wire [7:0] mixed_audio;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio1(audio1),
        .audio2(audio2),
        .audio3(audio3),
        .mixed_audio(mixed_audio)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum Values (All Zeros)", test_num);
            audio1 = 8'd0;
            audio2 = 8'd0;
            audio3 = 8'd0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Values (All 255)", test_num);
            audio1 = 8'd255;
            audio2 = 8'd255;
            audio3 = 8'd255;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Average (Even Division)", test_num);
            audio1 = 8'd100;
            audio2 = 8'd150;
            audio3 = 8'd200;
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Truncation Check (Sum = 31)", test_num);
            audio1 = 8'd10;
            audio2 = 8'd10;
            audio3 = 8'd11;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: One High Input", test_num);
            audio1 = 8'd255;
            audio2 = 8'd0;
            audio3 = 8'd0;
            #1;

            check_outputs(8'd85);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed Values Check", test_num);
            audio1 = 8'd128;
            audio2 = 8'd64;
            audio3 = 8'd32;
            #1;

            check_outputs(8'd74);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Near Maximum Truncation (Sum = 764)", test_num);
            audio1 = 8'd255;
            audio2 = 8'd255;
            audio3 = 8'd254;
            #1;

            check_outputs(8'd254);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small Signal Average", test_num);
            audio1 = 8'd1;
            audio2 = 8'd1;
            audio3 = 8'd1;
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Result Zero via Truncation", test_num);
            audio1 = 8'd0;
            audio2 = 8'd1;
            audio3 = 8'd1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random Values Check", test_num);
            audio1 = 8'd200;
            audio2 = 8'd50;
            audio3 = 8'd25;
            #1;

            check_outputs(8'd91);
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
