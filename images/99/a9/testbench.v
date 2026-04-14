`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg clock_100hz;
    reg clock_100khz;
    reg clock_10hz;
    reg clock_10khz;
    reg clock_12mhz;
    reg clock_1hz;
    reg clock_1khz;
    reg clock_1mhz;
    reg clock_25mhz;
    reg reset;
    reg sel_100hz;
    reg sel_100khz;
    reg sel_10hz;
    reg sel_10khz;
    reg sel_12mhz;
    reg sel_1hz;
    reg sel_1khz;
    reg sel_1mhz;
    reg sel_25mhz;
    wire clock_saida;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .clock_100hz(clock_100hz),
        .clock_100khz(clock_100khz),
        .clock_10hz(clock_10hz),
        .clock_10khz(clock_10khz),
        .clock_12mhz(clock_12mhz),
        .clock_1hz(clock_1hz),
        .clock_1khz(clock_1khz),
        .clock_1mhz(clock_1mhz),
        .clock_25mhz(clock_25mhz),
        .reset(reset),
        .sel_100hz(sel_100hz),
        .sel_100khz(sel_100khz),
        .sel_10hz(sel_10hz),
        .sel_10khz(sel_10khz),
        .sel_12mhz(sel_12mhz),
        .sel_1hz(sel_1hz),
        .sel_1khz(sel_1khz),
        .sel_1mhz(sel_1mhz),
        .sel_25mhz(sel_25mhz),
        .clock_saida(clock_saida)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            sel_1hz = 0; sel_10hz = 0; sel_100hz = 0; sel_1khz = 0;
            sel_10khz = 0; sel_100khz = 0; sel_1mhz = 0; sel_12mhz = 0; sel_25mhz = 0;
            clock_1hz = 0; clock_10hz = 0; clock_100hz = 0; clock_1khz = 0;
            clock_10khz = 0; clock_100khz = 0; clock_1mhz = 0; clock_12mhz = 0; clock_25mhz = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset Behavior", test_num);
            reset = 1;
            #10;
            #1;

            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Select 1Hz Clock", test_num);
            reset_dut();
            sel_1hz = 1;
            clock_1hz = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Select 10Hz Clock", test_num);
            reset_dut();
            sel_10hz = 1;
            clock_10hz = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Select 100Hz Clock", test_num);
            reset_dut();
            sel_100hz = 1;
            clock_100hz = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Select 1kHz Clock", test_num);
            reset_dut();
            sel_1khz = 1;
            clock_1khz = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Select 10kHz Clock", test_num);
            reset_dut();
            sel_10khz = 1;
            clock_10khz = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Select 100kHz Clock", test_num);
            reset_dut();
            sel_100khz = 1;
            clock_100khz = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Select 1MHz Clock", test_num);
            reset_dut();
            sel_1mhz = 1;
            clock_1mhz = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Select 12MHz Clock", test_num);
            reset_dut();
            sel_12mhz = 1;
            clock_12mhz = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Select 25MHz Clock", test_num);
            reset_dut();
            sel_25mhz = 1;
            clock_25mhz = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test Case %0d: No Selection Selected", test_num);
            reset_dut();

            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test Case %0d: Dynamic Switching 1Hz to 25MHz", test_num);
            reset_dut();


            sel_1hz = 1;
            clock_1hz = 1;
            @(posedge clock);
            #1;


            sel_1hz = 0;
            sel_25mhz = 1;
            clock_25mhz = 0;
            @(posedge clock);
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
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input expected_clock_saida;
        begin
            if (expected_clock_saida === (expected_clock_saida ^ clock_saida ^ expected_clock_saida)) begin
                $display("PASS");
                $display("  Outputs: clock_saida=%b",
                         clock_saida);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clock_saida=%b",
                         expected_clock_saida);
                $display("  Got:      clock_saida=%b",
                         clock_saida);
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
        $dumpvars(0,clock, clock_100hz, clock_100khz, clock_10hz, clock_10khz, clock_12mhz, clock_1hz, clock_1khz, clock_1mhz, clock_25mhz, reset, sel_100hz, sel_100khz, sel_10hz, sel_10khz, sel_12mhz, sel_1hz, sel_1khz, sel_1mhz, sel_25mhz, clock_saida);
    end

endmodule
