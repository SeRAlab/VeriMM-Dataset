`timescale 1ns/1ps

module dynamic_range_compressor_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] audio_in;
    reg clk;
    reg rst;
    wire [3:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dynamic_range_compressor dut (
        .audio_in(audio_in),
        .clk(clk),
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
            audio_in = 4'b0;
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
            audio_in = 4'sd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'sd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            audio_in = 4'sd5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'sd5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            audio_in = 4'sd7;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'sd7);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            audio_in = -4'sd3;
            @(posedge clk);
            #1;

            #1;


            check_outputs(-4'sd3);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            audio_in = -4'sd8;
            @(posedge clk);
            #1;


            #1;



            check_outputs(-4'sd8);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            audio_in = 4'sd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'sd2);
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
        $dumpvars(0,audio_in, clk, rst, audio_out);
    end

endmodule
