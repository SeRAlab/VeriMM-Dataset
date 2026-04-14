`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_ref;
    reg data_in;
    reg en;
    wire data_out;
    wire locked;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_ref(clk_ref),
        .data_in(data_in),
        .en(en),
        .data_out(data_out),
        .locked(locked)
    );

    // Clock generation (10ns period)
    initial begin
        clk_ref = 0;
        forever #5 clk_ref = ~clk_ref;
    end

        task reset_dut;

        begin
            en = 0;
            data_in = 0;
            #20;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Disabled State Check");
            test_num = 1;
            reset_dut();

            en = 0;
            data_in = 0;
            #100;



            #1;




            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Lock Acquisition (Steady High)");
            test_num = 2;
            reset_dut();

            en = 1;
            data_in = 1;


            #5000;


            #1;



            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Dynamic Signal Tracking");
            test_num = 3;
            reset_dut();

            en = 1;



            fork
                begin
                    repeat(200) begin
                        data_in = 1; #20;
                        data_in = 0; #20;
                    end
                end
            join_none


            #8000;




            if (locked === 1'b1) begin
                pass_count = pass_count + 1;
                $display("PASS: DLL Locked with dynamic input");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: DLL failed to lock with dynamic input");
            end
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Enable/Disable Recovery");
            test_num = 4;
            reset_dut();


            en = 1;
            data_in = 1;
            #2000;


            en = 0;
            #100;


            en = 1;
            #5000;

            #1;


            check_outputs(1'b1, 1'b1);
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
        input expected_data_out;
        input expected_locked;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_locked === (expected_locked ^ locked ^ expected_locked)) begin
                $display("PASS");
                $display("  Outputs: data_out=%b, locked=%b",
                         data_out, locked);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%b, locked=%b",
                         expected_data_out, expected_locked);
                $display("  Got:      data_out=%b, locked=%b",
                         data_out, locked);
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
        $dumpvars(0,clk_ref, data_in, en, data_out, locked);
    end

endmodule
