`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk50mhz;
    reg ear;
    reg reset;
    wire mic;
    wire spk;
    wire sync;
    wire video;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk50mhz(clk50mhz),
        .ear(ear),
        .reset(reset),
        .mic(mic),
        .spk(spk),
        .sync(sync),
        .video(video)
    );

    // Clock generation (10ns period)
    initial begin
        clk50mhz = 0;
        forever #5 clk50mhz = ~clk50mhz;
    end

        task reset_dut;

        begin
            reset = 1;
            ear = 0;
            @(negedge clk50mhz);
            reset = 0;


        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Ear High, 4 cycles (Sync High check)", test_num);
            reset_dut();
            ear = 1;
            repeat(4) @(posedge clk50mhz);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Ear Low, 4 cycles (Sync High check)", test_num);
            reset_dut();
            ear = 0;
            repeat(4) @(posedge clk50mhz);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sync Low check at cycle 2", test_num);
            reset_dut();
            ear = 1;
            repeat(2) @(posedge clk50mhz);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Video Toggle check at cycle 1", test_num);
            reset_dut();
            ear = 0;
            repeat(1) @(posedge clk50mhz);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sync Wrap Around check at cycle 8", test_num);
            reset_dut();
            ear = 1;
            repeat(8) @(posedge clk50mhz);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Video Toggle check at cycle 3", test_num);
            reset_dut();
            ear = 0;
            repeat(3) @(posedge clk50mhz);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_mic;
        input expected_spk;
        input expected_sync;
        input expected_video;
        begin
            if (expected_mic === (expected_mic ^ mic ^ expected_mic) &&
                expected_spk === (expected_spk ^ spk ^ expected_spk) &&
                expected_sync === (expected_sync ^ sync ^ expected_sync) &&
                expected_video === (expected_video ^ video ^ expected_video)) begin
                $display("PASS");
                $display("  Outputs: mic=%b, spk=%b, sync=%b, video=%b",
                         mic, spk, sync, video);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mic=%b, spk=%b, sync=%b, video=%b",
                         expected_mic, expected_spk, expected_sync, expected_video);
                $display("  Got:      mic=%b, spk=%b, sync=%b, video=%b",
                         mic, spk, sync, video);
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
        $dumpvars(0,clk50mhz, ear, reset, mic, spk, sync, video);
    end

endmodule
