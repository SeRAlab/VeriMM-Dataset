`timescale 1ns/1ps

module sample_rate_converter_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_in;
    reg clk;
    reg rst;
    wire [15:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sample_rate_converter dut (
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
            audio_in = 16'h0000;
            #20;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Verify first sample in sequence", test_num);
            reset_dut();

            @(posedge clk); audio_in = 16'hA1B1;
            @(posedge clk); audio_in = 16'hC2D2;
            @(posedge clk); audio_in = 16'h0000;


            #2;
            #1;

            check_outputs(16'hA1B1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Verify second sample in sequence", test_num);
            reset_dut();

            @(posedge clk); audio_in = 16'h1111;
            @(posedge clk); audio_in = 16'h2222;
            @(posedge clk); audio_in = 16'h3333;
            @(posedge clk); audio_in = 16'h0000;

            #2;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Max/Min edge values", test_num);
            reset_dut();

            @(posedge clk); audio_in = 16'hFFFF;
            @(posedge clk); audio_in = 16'h0000;
            @(posedge clk); audio_in = 16'h1234;

            #2;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Alternating bit patterns", test_num);
            reset_dut();

            @(posedge clk); audio_in = 16'hAAAA;
            @(posedge clk); audio_in = 16'h5555;
            @(posedge clk); audio_in = 16'h0000;

            #2;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Reset clears output", test_num);
            reset_dut();

            @(posedge clk); audio_in = 16'hBCDE;
            @(posedge clk); audio_in = 16'hF0F0;


            rst = 1;
            #20;
            rst = 0;
            @(posedge clk);

            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sample_rate_converter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        $dumpvars(0,audio_in, clk, rst, audio_out);
    end

endmodule
