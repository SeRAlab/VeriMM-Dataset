`timescale 1ns/1ps

module audio_compressor_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] audio_in;
    reg clk;
    reg [7:0] threshold;
    wire [7:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    audio_compressor dut (
        .audio_in(audio_in),
        .clk(clk),
        .threshold(threshold),
        .audio_out(audio_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            audio_in <= 0;
            threshold <= 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTest Case %0d: Input below threshold", test_num);
            audio_in <= 8'h40;
            threshold <= 8'h80;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTest Case %0d: Input above threshold", test_num);
            audio_in <= 8'hA0;
            threshold <= 8'h80;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h50);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTest Case %0d: Input equal to threshold", test_num);
            audio_in <= 8'h7F;
            threshold <= 8'h7F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTest Case %0d: Max input (255) compressed", test_num);
            audio_in <= 8'hFF;
            threshold <= 8'h10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTest Case %0d: Zero input", test_num);
            audio_in <= 8'h00;
            threshold <= 8'h20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("\nTest Case %0d: Odd value compression", test_num);
            audio_in <= 8'h97;
            threshold <= 8'h10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h4B);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("audio_compressor Testbench");
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
        $dumpvars(0,audio_in, clk, threshold, audio_out);
    end

endmodule
