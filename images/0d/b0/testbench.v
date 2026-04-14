`timescale 1ns/1ps

module pitch_detection_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg signal_in;
    wire [15:0] pitch_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detection dut (
        .clk(clk),
        .reset(reset),
        .signal_in(signal_in),
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
            signal_in = 0;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: DC Signal (Zero Frequency)", test_num);
            reset_dut();
            signal_in = 0;
            #(WINDOW_TIME);
            @(posedge clk);
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Low Frequency (1MHz)", test_num);
            reset_dut();
            fork
                begin
                    for (i = 0; i < 10; i = i + 1) begin
                        signal_in = 1; #500;
                        signal_in = 0; #500;
                    end
                end
            join_any
            @(posedge clk);
            #1;

            check_outputs(16'd20);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Medium Frequency (5MHz)", test_num);
            reset_dut();
            fork
                begin
                    for (i = 0; i < 50; i = i + 1) begin
                        signal_in = 1; #100;
                        signal_in = 0; #100;
                    end
                end
            join_any
            @(posedge clk);
            #1;

            check_outputs(16'd100);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: High Frequency (25MHz)", test_num);
            reset_dut();
            fork
                begin
                    for (i = 0; i < 250; i = i + 1) begin
                        signal_in = 1; #20;
                        signal_in = 0; #20;
                    end
                end
            join_any
            @(posedge clk);
            #1;

            check_outputs(16'd500);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nRunning Testcase %0d: Static High Signal", test_num);
            reset_dut();
            signal_in = 1;
            #(WINDOW_TIME);
            @(posedge clk);
            #1;

            check_outputs(16'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pitch_detection Testbench");
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
        input [15:0] expected_pitch_out;
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
        $dumpvars(0,clk, reset, signal_in, pitch_out);
    end

endmodule
