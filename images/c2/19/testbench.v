`timescale 1ns/1ps

module sync_counter_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] data_in;
    reg load;
    reg reset;
    wire [3:0] count_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_counter dut (
        .clock(clock),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .count_out(count_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            load = 0;
            data_in = 0;
            #10;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Reset");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Asynchronous Load");
            test_num = 2;
            reset_dut();
            data_in = 4'hA;
            load = 1;
            #2;
            #1;

            check_outputs(4'hA);
            load = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Synchronous Increment");
            test_num = 3;
            reset_dut();

            @(posedge clock);
            @(posedge clock);
            @(posedge clock);
            #2;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Counter Wrap-around");
            test_num = 4;
            reset_dut();

            data_in = 4'hF;
            load = 1;
            #2;
            load = 0;

            @(posedge clock);
            #2;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Load Priority/Functionality during Clock");
            test_num = 5;
            reset_dut();
            @(posedge clock);
            #2;
            data_in = 4'h7;
            load = 1;
            #2;
            #1;

            check_outputs(4'h7);
            load = 0;
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Reset Priority over Load");
            test_num = 6;
            reset_dut();
            data_in = 4'hE;
            load = 1;
            #2;
            reset = 1;
            #2;
            #1;

            check_outputs(4'h0);
            reset = 0;
            load = 0;
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Sequential Counting");
            test_num = 7;
            reset_dut();
            repeat(10) @(posedge clock);
            #2;
            #1;

            check_outputs(4'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_counter Testbench");
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
        input [3:0] expected_count_out;
        begin
            if (expected_count_out === (expected_count_out ^ count_out ^ expected_count_out)) begin
                $display("PASS");
                $display("  Outputs: count_out=%h",
                         count_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count_out=%h",
                         expected_count_out);
                $display("  Got:      count_out=%h",
                         count_out);
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
        $dumpvars(0,clock, data_in, load, reset, count_out);
    end

endmodule
