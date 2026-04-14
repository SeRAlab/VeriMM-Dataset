`timescale 1ns/1ps

module audio_mixer_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] audio_in1;
    reg [7:0] audio_in2;
    reg clk;
    reg rst;
    reg [7:0] volume1;
    reg [7:0] volume2;
    wire [7:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_mixer dut (
        .audio_in1(audio_in1),
        .audio_in2(audio_in2),
        .clk(clk),
        .rst(rst),
        .volume1(volume1),
        .volume2(volume2),
        .audio_out(audio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            audio_in1 = 0;
            audio_in2 = 0;
            volume1 = 0;
            volume2 = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input 1 full contribution, Input 2 none", test_num);
            reset_dut();
            audio_in1 = 8'd150;
            audio_in2 = 8'd200;
            volume1   = 8'd255;
            volume2   = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Input 2 full contribution, Input 1 none", test_num);
            reset_dut();
            audio_in1 = 8'd200;
            audio_in2 = 8'd75;
            volume1   = 8'd0;
            volume2   = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd75);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mixing both signals (No Overflow)", test_num);
            reset_dut();
            audio_in1 = 8'd100;
            audio_in2 = 8'd50;
            volume1   = 8'd255;
            volume2   = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd150);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mixing with Clamping (Overflow)", test_num);
            reset_dut();
            audio_in1 = 8'd200;
            audio_in2 = 8'd200;
            volume1   = 8'd255;
            volume2   = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max inputs with zero volume", test_num);
            reset_dut();
            audio_in1 = 8'd255;
            audio_in2 = 8'd255;
            volume1   = 8'd0;
            volume2   = 8'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Minimum non-zero mixing", test_num);
            reset_dut();
            audio_in1 = 8'd1;
            audio_in2 = 8'd1;
            volume1   = 8'd255;
            volume2   = 8'd255;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd2);
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
        input [7:0] expected_audio_out;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,audio_in1, audio_in2, clk, rst, volume1, volume2, audio_out);
    end

endmodule
