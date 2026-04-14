`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_in;
    reg clk;
    reg [3:0] compression_ratio;
    reg enable;
    reg rst;
    wire [15:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .audio_in(audio_in),
        .clk(clk),
        .compression_ratio(compression_ratio),
        .enable(enable),
        .rst(rst),
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
            audio_in = 0;
            compression_ratio = 1;
            enable = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Bypass Mode (Enable=0)", test_num);
            audio_in = 16'sd1000;
            compression_ratio = 4'd4;
            enable = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'sd1000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: 2:1 Compression (Positive Input)", test_num);
            audio_in = 16'sd4000;
            compression_ratio = 4'd2;
            enable = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'sd2000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: 2:1 Compression (Negative Input)", test_num);
            audio_in = -16'sd4000;
            compression_ratio = 4'd2;
            enable = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(-16'sd2000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: 10:1 Compression", test_num);
            audio_in = 16'sd15000;
            compression_ratio = 4'd10;
            enable = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'sd1500);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: 1:1 Ratio (Enabled)", test_num);
            audio_in = 16'sd750;
            compression_ratio = 4'd1;
            enable = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'sd750);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Max Positive Value / 8", test_num);
            audio_in = 16'h7FFF;
            compression_ratio = 4'd8;
            enable = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'sd32767 / 16'sd8);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Max Negative Value / 4", test_num);
            audio_in = 16'h8000;
            compression_ratio = 4'd4;
            enable = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(-16'sd32768 / 16'sd4);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %0d: Zero Input", test_num);
            audio_in = 16'sd0;
            compression_ratio = 4'd5;
            enable = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'sd0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Testcase %0d: Small Signal Integer Division", test_num);
            audio_in = 16'sd3;
            compression_ratio = 4'd4;
            enable = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'sd0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("Testcase %0d: Dynamic Ratio Change", test_num);
            audio_in = 16'sd100;
            compression_ratio = 4'd2;
            enable = 1'b1;
            @(posedge clk);
            #2;

            if (audio_out !== 16'sd50) $display("Subtest Fail at Ratio 2");


            compression_ratio = 4'd4;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'sd25);
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
        $dumpvars(0,audio_in, clk, compression_ratio, enable, rst, audio_out);
    end

endmodule
