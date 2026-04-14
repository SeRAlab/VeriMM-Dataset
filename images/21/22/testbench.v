`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] audio_in1;
    reg [7:0] audio_in2;
    reg clk;
    reg [2:0] vol_ctrl1;
    reg [2:0] vol_ctrl2;
    wire [8:0] mixed_audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio_in1(audio_in1),
        .audio_in2(audio_in2),
        .clk(clk),
        .vol_ctrl1(vol_ctrl1),
        .vol_ctrl2(vol_ctrl2),
        .mixed_audio_out(mixed_audio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            audio_in1 = 8'd0;
            audio_in2 = 8'd0;
            vol_ctrl1 = 3'd0;
            vol_ctrl2 = 3'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros (Silence)", test_num);
            audio_in1 = 8'd0;
            audio_in2 = 8'd0;
            vol_ctrl1 = 3'd0;
            vol_ctrl2 = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Max Inputs and Max Volume", test_num);
            audio_in1 = 8'hFF;
            audio_in2 = 8'hFF;
            vol_ctrl1 = 3'd7;
            vol_ctrl2 = 3'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd446);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 1 Passthrough (Channel 2 Muted)", test_num);
            audio_in1 = 8'd200;
            audio_in2 = 8'd100;
            vol_ctrl1 = 3'd4;
            vol_ctrl2 = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd100);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Channel 2 Passthrough (Channel 1 Muted)", test_num);
            audio_in1 = 8'd50;
            audio_in2 = 8'd128;
            vol_ctrl1 = 3'd0;
            vol_ctrl2 = 3'd6;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd96);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Balanced Low Volume Mix", test_num);
            audio_in1 = 8'd128;
            audio_in2 = 8'd128;
            vol_ctrl1 = 3'd2;
            vol_ctrl2 = 3'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd64);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Asymmetric Weighted Mix", test_num);
            audio_in1 = 8'd255;
            audio_in2 = 8'd64;
            vol_ctrl1 = 3'd6;
            vol_ctrl2 = 3'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(9'd207);
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
        input [8:0] expected_mixed_audio_out;
        begin
            if (expected_mixed_audio_out === (expected_mixed_audio_out ^ mixed_audio_out ^ expected_mixed_audio_out)) begin
                $display("PASS");
                $display("  Outputs: mixed_audio_out=%h",
                         mixed_audio_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mixed_audio_out=%h",
                         expected_mixed_audio_out);
                $display("  Got:      mixed_audio_out=%h",
                         mixed_audio_out);
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
        $dumpvars(0,audio_in1, audio_in2, clk, vol_ctrl1, vol_ctrl2, mixed_audio_out);
    end

endmodule
