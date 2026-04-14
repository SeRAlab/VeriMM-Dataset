`timescale 1ns/1ps

module pulse_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] period;
    reg start;
    reg [3:0] width;
    wire pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pulse_generator dut (
        .clk(clk),
        .period(period),
        .start(start),
        .width(width),
        .pulse(pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            width = 0;
            period = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            width = 4'd3; period = 4'd6;
            @(posedge clk); start = 1;
            @(posedge clk); start = 0;
            #1;
            $display("Test 001: Width 3, Cycle 1 - Expect Pulse=1");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            width = 4'd3; period = 4'd6;
            @(posedge clk); start = 1;
            @(posedge clk); start = 0;
            repeat(2) @(posedge clk);
            #1;
            $display("Test 002: Width 3, Cycle 3 - Expect Pulse=1");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            width = 4'd3; period = 4'd6;
            @(posedge clk); start = 1;
            @(posedge clk); start = 0;
            repeat(3) @(posedge clk);
            #1;
            $display("Test 003: Width 3, Cycle 4 - Expect Pulse=0");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            width = 4'd1; period = 4'd4;
            @(posedge clk); start = 1;
            @(posedge clk); start = 0;
            #1;
            $display("Test 004: Width 1, Cycle 1 - Expect Pulse=1");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            width = 4'd1; period = 4'd4;
            @(posedge clk); start = 1;
            @(posedge clk); start = 0;
            repeat(1) @(posedge clk);
            #1;
            $display("Test 005: Width 1, Cycle 2 - Expect Pulse=0");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            width = 4'd15; period = 4'd15;
            @(posedge clk); start = 1;
            @(posedge clk); start = 0;
            repeat(14) @(posedge clk);
            #1;
            $display("Test 006: Width 15, Cycle 15 - Expect Pulse=1");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            width = 4'd0; period = 4'd5;
            @(posedge clk); start = 1;
            @(posedge clk); start = 0;
            #1;
            $display("Test 007: Width 0, Cycle 1 - Expect Pulse=0");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            width = 4'd2; period = 4'd8;
            @(posedge clk); start = 1;
            @(posedge clk); start = 0;
            repeat(7) @(posedge clk);
            #1;
            $display("Test 008: Period 8, Cycle 8 - Expect Pulse=0");
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pulse_generator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_pulse;
        begin
            if (expected_pulse === (expected_pulse ^ pulse ^ expected_pulse)) begin
                $display("PASS");
                $display("  Outputs: pulse=%b",
                         pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pulse=%b",
                         expected_pulse);
                $display("  Got:      pulse=%b",
                         pulse);
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
        $dumpvars(0,clk, period, start, width, pulse);
    end

endmodule
