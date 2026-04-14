`timescale 1ns/1ps

module count_signal_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] period;
    reg signal;
    wire [31:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    count_signal dut (
        .clk(clk),
        .period(period),
        .signal(signal),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            signal <= 0;
            period <= 2;
            repeat(5) @(posedge clk);
        end
        endtask
    task testcase001;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Period 10, Max Frequency Pulses (5 expected)", test_num);
            reset_dut();
            period = 10;
            @(posedge clk);
            for (i = 0; i < 5; i = i + 1) begin
                signal = 1; @(posedge clk);
                signal = 0; @(posedge clk);
            end

            @(posedge clk);
            #1;
            #1;

            check_outputs(5);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Period 6, Max Frequency Pulses (3 expected)", test_num);
            reset_dut();
            period = 6;
            @(posedge clk);
            for (i = 0; i < 3; i = i + 1) begin
                signal = 1; @(posedge clk);
                signal = 0; @(posedge clk);
            end
            @(posedge clk);
            #1;
            #1;

            check_outputs(3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Period 8, 2 pulses (2 expected)", test_num);
            reset_dut();
            period = 8;
            @(posedge clk);

            signal = 1; @(posedge clk);
            signal = 0; @(posedge clk);
            signal = 0; @(posedge clk);
            signal = 0; @(posedge clk);

            signal = 1; @(posedge clk);
            signal = 0; @(posedge clk);
            signal = 0; @(posedge clk);
            signal = 0; @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Period 4, No pulses (0 expected)", test_num);
            reset_dut();
            period = 4;
            signal = 0;
            repeat(4) @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Period 2, 1 pulse (1 expected)", test_num);
            reset_dut();
            period = 2;
            @(posedge clk);
            signal = 1; @(posedge clk);
            signal = 0; @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Period 20, Sporadic pulses (4 expected)", test_num);
            reset_dut();
            period = 20;
            @(posedge clk);
            signal = 1; @(posedge clk);
            signal = 0; @(posedge clk);
            repeat(8) @(posedge clk);
            signal = 1; @(posedge clk);
            signal = 0; @(posedge clk);
            signal = 1; @(posedge clk);
            signal = 0; @(posedge clk);
            signal = 1; @(posedge clk);
            signal = 0; @(posedge clk);
            repeat(4) @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(4);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("count_signal Testbench");
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
        input [31:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, period, signal, count);
    end

endmodule
