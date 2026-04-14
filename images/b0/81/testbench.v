`timescale 1ns/1ps

module debouncer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg signal_in;
    reg [31:0] stable_count;
    wire signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    debouncer dut (
        .clk(clk),
        .rst(rst),
        .signal_in(signal_in),
        .stable_count(stable_count),
        .signal_out(signal_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            signal_in = 0;
            stable_count = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Debouncing - Stable signal high for 5 cycles");
            test_num = 1;
            reset_dut();
            stable_count = 5;


            repeat (5) begin
                signal_in = 1;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Insufficient Stability - High for 3 cycles, required 5");
            test_num = 2;
            reset_dut();
            stable_count = 5;


            repeat (3) begin
                signal_in = 1;
                @(posedge clk);
            end


            signal_in = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Noisy Signal - Glitches followed by stable high");
            test_num = 3;
            reset_dut();
            stable_count = 4;


            repeat (2) begin
                signal_in = 1;
                @(posedge clk);
            end
            signal_in = 0;
            @(posedge clk);


            repeat (4) begin
                signal_in = 1;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Large Count - Testing stable_count = 20");
            test_num = 4;
            reset_dut();
            stable_count = 20;

            repeat (20) begin
                signal_in = 1;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Reset during operation");
            test_num = 5;
            reset_dut();
            stable_count = 10;


            repeat (8) begin
                signal_in = 1;
                @(posedge clk);
            end


            rst = 1;
            @(posedge clk);
            rst = 0;


            repeat (5) begin
                signal_in = 1;
                @(posedge clk);
            end

            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Signal remains low");
            test_num = 6;
            reset_dut();
            stable_count = 5;

            signal_in = 0;
            repeat (10) @(posedge clk);

            #1;
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
        $display("debouncer Testbench");
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
        input expected_signal_out;
        begin
            if (expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: signal_out=%b",
                         signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: signal_out=%b",
                         expected_signal_out);
                $display("  Got:      signal_out=%b",
                         signal_out);
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
        $dumpvars(0,clk, rst, signal_in, stable_count, signal_out);
    end

endmodule
