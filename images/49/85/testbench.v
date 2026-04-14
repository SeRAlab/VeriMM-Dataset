`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg k_tr;
    wire [7:0] key_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .k_tr(k_tr),
        .key_code(key_code)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            k_tr = 0;
            repeat(10) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Checking Idle State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Pulse Trigger - Initial Sound Code", test_num);
            reset_dut();
            k_tr = 1;
            @(posedge clock);
            k_tr = 0;
            repeat(2) @(posedge clock);


            #1;



            check_outputs(8'h1E);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Verify Progression to Second Sound State", test_num);
            reset_dut();
            k_tr = 1;
            @(posedge clock);
            k_tr = 0;

            repeat(20) @(posedge clock);

            #1;


            check_outputs(8'h2D);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Verify Progression to Third Sound State", test_num);
            reset_dut();
            k_tr = 1;
            @(posedge clock);
            k_tr = 0;

            repeat(40) @(posedge clock);

            #1;


            check_outputs(8'h3C);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Sequence Completion Check", test_num);
            reset_dut();
            k_tr = 1;
            @(posedge clock);
            k_tr = 0;

            repeat(200) @(posedge clock);

            #1;


            check_outputs(8'h00);
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
        input [7:0] expected_key_code;
        begin
            if (expected_key_code === (expected_key_code ^ key_code ^ expected_key_code)) begin
                $display("PASS");
                $display("  Outputs: key_code=%h",
                         key_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: key_code=%h",
                         expected_key_code);
                $display("  Got:      key_code=%h",
                         key_code);
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
        $dumpvars(0,clock, k_tr, key_code);
    end

endmodule
