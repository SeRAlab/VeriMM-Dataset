`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg button_0;
    reg button_1;
    reg button_2;
    reg button_3;
    reg clock_27mhz;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .button_0(button_0),
        .button_1(button_1),
        .button_2(button_2),
        .button_3(button_3),
        .clock_27mhz(clock_27mhz),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clock_27mhz = 0;
        forever #5 clock_27mhz = ~clock_27mhz;
    end

        task reset_dut;

        begin
            button_0 = 1;
            button_1 = 0;
            button_2 = 0;
            button_3 = 0;
            repeat(2) @(posedge clock_27mhz);
            button_0 = 0;
            @(posedge clock_27mhz);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Power-on Reset check", test_num);
            reset_dut();

            #1;


            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition to Learning State", test_num);
            reset_dut();
            button_1 = 1;
            @(posedge clock_27mhz);
            button_1 = 0;
            repeat(5) @(posedge clock_27mhz);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition to Playback State", test_num);
            reset_dut();
            button_2 = 1;
            @(posedge clock_27mhz);
            button_2 = 0;
            repeat(5) @(posedge clock_27mhz);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition to Blah State", test_num);
            reset_dut();
            button_3 = 1;
            @(posedge clock_27mhz);
            button_3 = 0;
            repeat(5) @(posedge clock_27mhz);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: State Sequence Transition", test_num);
            reset_dut();


            button_1 = 1; @(posedge clock_27mhz); button_1 = 0;
            repeat(2) @(posedge clock_27mhz);


            button_2 = 1; @(posedge clock_27mhz); button_2 = 0;
            repeat(2) @(posedge clock_27mhz);


            button_3 = 1; @(posedge clock_27mhz); button_3 = 0;
            repeat(2) @(posedge clock_27mhz);

            #1;


            check_outputs(0);
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
        $dumpvars(0,button_0, button_1, button_2, button_3, clock_27mhz, out);
    end

endmodule
