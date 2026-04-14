`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] audio1;
    reg [7:0] audio2;
    reg clk;
    wire [7:0] mixed_audio;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio1(audio1),
        .audio2(audio2),
        .clk(clk),
        .mixed_audio(mixed_audio)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            audio1 <= 8'h00;
            audio2 <= 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Zero inputs", test_num);
            audio1 <= 8'd0;
            audio2 <= 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Simple addition (10 + 20)", test_num);
            audio1 <= 8'd10;
            audio2 <= 8'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Boundary addition (128 + 127)", test_num);
            audio1 <= 8'd128;
            audio2 <= 8'd127;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Overflow clamping (130 + 130)", test_num);
            audio1 <= 8'd130;
            audio2 <= 8'd130;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Max overflow clamping (255 + 255)", test_num);
            audio1 <= 8'd255;
            audio2 <= 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Identity test (0 + 100)", test_num);
            audio1 <= 8'd0;
            audio2 <= 8'd100;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Identity test (100 + 0)", test_num);
            audio1 <= 8'd100;
            audio2 <= 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: Overflow test (255 + 1)", test_num);
            audio1 <= 8'd255;
            audio2 <= 8'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,audio1, audio2, clk, mixed_audio);
    end

endmodule
