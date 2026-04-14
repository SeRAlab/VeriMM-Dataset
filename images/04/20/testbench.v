`timescale 1ns/1ps

module pitch_detection_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg sample;
    wire [3:0] pitch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pitch_detection dut (
        .clk(clk),
        .reset(reset),
        .sample(sample),
        .pitch(pitch)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            sample = 0;
            @(negedge clk);
            reset = 0;
            $display("DUT Reset completed.");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Three consecutive high samples", test_num);
            reset_dut();
            @(negedge clk) sample = 1;
            @(negedge clk) sample = 1;
            @(negedge clk) sample = 1;
            @(posedge clk);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All low samples", test_num);
            reset_dut();
            @(negedge clk) sample = 0;
            @(negedge clk) sample = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Interrupted sequence (1, 1, 0, 1)", test_num);
            reset_dut();
            @(negedge clk) sample = 1;
            @(negedge clk) sample = 1;
            @(negedge clk) sample = 0;
            @(negedge clk) sample = 1;
            @(posedge clk);
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 15 consecutive high samples (Max 4-bit)", test_num);
            reset_dut();
            for (i = 0; i < 15; i = i + 1) begin
                @(negedge clk) sample = 1;
            end
            @(posedge clk);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset signal triggered mid-sequence", test_num);
            reset_dut();
            @(negedge clk) sample = 1;
            @(negedge clk) sample = 1;
            @(negedge clk) reset = 1;
            @(negedge clk) reset = 0;
            @(posedge clk);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single high sample", test_num);
            reset_dut();
            @(negedge clk) sample = 1;
            @(posedge clk);
            #1;

            check_outputs(4'd1);
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
        input [3:0] expected_pitch;
        begin
            if (expected_pitch === (expected_pitch ^ pitch ^ expected_pitch)) begin
                $display("PASS");
                $display("  Outputs: pitch=%h",
                         pitch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pitch=%h",
                         expected_pitch);
                $display("  Got:      pitch=%h",
                         pitch);
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
        $dumpvars(0,clk, reset, sample, pitch);
    end

endmodule
