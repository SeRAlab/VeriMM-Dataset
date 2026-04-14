`timescale 1ns/1ps

module echo_cancellation_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] audio_in;
    reg clk;
    reg [15:0] echo_in;
    reg rst;
    wire [15:0] audio_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    echo_cancellation dut (
        .audio_in(audio_in),
        .clk(clk),
        .echo_in(echo_in),
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
            echo_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero signals", test_num);
            reset_dut();

            audio_in = 16'h0000;
            echo_in = 16'h0000;


            repeat(4) @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Audio signal, zero echo", test_num);
            reset_dut();

            audio_in = 16'h1234;
            echo_in = 16'h0000;

            repeat(4) @(posedge clk);

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple cancellation", test_num);
            reset_dut();

            audio_in = 16'h5000;
            echo_in = 16'h1000;

            repeat(4) @(posedge clk);

            #1;


            check_outputs(16'h4000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Complete echo cancellation", test_num);
            reset_dut();

            audio_in = 16'hAAAA;
            echo_in = 16'hAAAA;

            repeat(4) @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Echo larger than signal (Negative result)", test_num);
            reset_dut();

            audio_in = 16'h0005;
            echo_in = 16'h000F;

            repeat(4) @(posedge clk);

            #1;


            check_outputs(16'hFFF6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max positive signed values", test_num);
            reset_dut();

            audio_in = 16'h7FFF;
            echo_in = 16'h0001;

            repeat(4) @(posedge clk);

            #1;


            check_outputs(16'h7FFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential processing test", test_num);
            reset_dut();


            audio_in = 16'h1000;
            echo_in = 16'h0100;
            repeat(4) @(posedge clk);


            audio_in = 16'h2000;
            echo_in = 16'h0200;
            repeat(4) @(posedge clk);

            #1;


            check_outputs(16'h1E00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("echo_cancellation Testbench");
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
        $dumpvars(0,audio_in, clk, echo_in, rst, audio_out);
    end

endmodule
