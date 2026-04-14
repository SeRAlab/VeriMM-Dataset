`timescale 1ns/1ps

module pitch_detector_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] frequency;
    reg reset;
    wire [3:0] pitch_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detector dut (
        .clk(clk),
        .frequency(frequency),
        .reset(reset),
        .pitch_out(pitch_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            frequency = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Minimum frequency (0)");
            reset_dut();
            frequency = 8'd0;

            repeat(20) @(posedge clk);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Lower-mid frequency (32)");
            reset_dut();
            frequency = 8'd32;
            repeat(20) @(posedge clk);

            #1;


            check_outputs(4'h2);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Mid frequency (128)");
            reset_dut();
            frequency = 8'd128;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: High frequency (200)");
            reset_dut();
            frequency = 8'd200;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Maximum frequency (255)");
            reset_dut();
            frequency = 8'd255;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Dynamic frequency transition");
            reset_dut();
            frequency = 8'd64;
            repeat(10) @(posedge clk);
            frequency = 8'd160;
            repeat(20) @(posedge clk);
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Output during reset");
            reset_dut();
            reset = 1;
            frequency = 8'd255;
            @(posedge clk);
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pitch_detector Testbench");
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
        input [3:0] expected_pitch_out;
        begin
            if (expected_pitch_out === (expected_pitch_out ^ pitch_out ^ expected_pitch_out)) begin
                $display("PASS");
                $display("  Outputs: pitch_out=%h",
                         pitch_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pitch_out=%h",
                         expected_pitch_out);
                $display("  Got:      pitch_out=%h",
                         pitch_out);
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
        $dumpvars(0,clk, frequency, reset, pitch_out);
    end

endmodule
