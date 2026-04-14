`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clock;
    reg S_in;
    reg Shift_control;
    reg [7:0] data;
    reg load;
    reg reset_b;
    wire SO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clock(Clock),
        .S_in(S_in),
        .Shift_control(Shift_control),
        .data(data),
        .load(load),
        .reset_b(reset_b),
        .SO(SO)
    );

    // Clock generation (10ns period)
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

        task reset_dut;

        begin
            reset_b = 0;
            S_in = 0;
            Shift_control = 0;
            data = 0;
            load = 0;
            @(posedge Clock);
            #2 reset_b = 1;
            @(posedge Clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Parallel Load (LSB=1)", test_num);
            reset_dut();
            data = 8'hA1;
            load = 1;
            @(posedge Clock);
            #1 load = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Parallel Load (LSB=0)", test_num);
            reset_dut();
            data = 8'hFE;
            load = 1;
            @(posedge Clock);
            #1 load = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Shift Left (In=1)", test_num);
            reset_dut();

            S_in = 1;
            Shift_control = 1;
            @(posedge Clock);
            #1 Shift_control = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Shift Left (In=0)", test_num);
            reset_dut();

            data = 8'h01;
            load = 1;
            @(posedge Clock);
            #1 load = 0;

            S_in = 0;
            Shift_control = 1;
            @(posedge Clock);
            #1 Shift_control = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Hold value (Shift_control=0)", test_num);
            reset_dut();
            data = 8'hFF;
            load = 1;
            @(posedge Clock);
            #1 load = 0;
            Shift_control = 0;
            S_in = 0;
            @(posedge Clock);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Multiple Shifts", test_num);
            reset_dut();
            Shift_control = 1;

            S_in = 1; @(posedge Clock);
            S_in = 1; @(posedge Clock);
            S_in = 0; @(posedge Clock);

            #1 Shift_control = 0;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Load and Shift active simultaneously", test_num);
            reset_dut();
            data = 8'h55;
            S_in = 0;
            load = 1;
            Shift_control = 1;
            @(posedge Clock);
            #1;




            #1;





            check_outputs(1'b1);
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
        input expected_SO;
        begin
            if (expected_SO === (expected_SO ^ SO ^ expected_SO)) begin
                $display("PASS");
                $display("  Outputs: SO=%b",
                         SO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SO=%b",
                         expected_SO);
                $display("  Got:      SO=%b",
                         SO);
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
        $dumpvars(0,Clock, S_in, Shift_control, data, load, reset_b, SO);
    end

endmodule
