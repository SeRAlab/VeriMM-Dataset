`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg in;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        in = 0;
        forever #5 in = ~in;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task drive_bit;

        input bit_val;
        begin
            in = bit_val;
            @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            $display("Running testcase001: Correct sequence '0110'");
            test_num = test_num + 1;
            reset_dut();
            drive_bit(0);
            drive_bit(1);
            drive_bit(1);
            drive_bit(0);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Incorrect sequence '0111'");
            test_num = test_num + 1;
            reset_dut();
            drive_bit(0);
            drive_bit(1);
            drive_bit(1);
            drive_bit(1);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sequence with leading noise '1110110'");
            test_num = test_num + 1;
            reset_dut();
            drive_bit(1);
            drive_bit(1);
            drive_bit(0);
            drive_bit(1);
            drive_bit(1);
            drive_bit(0);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Incomplete sequence '011'");
            test_num = test_num + 1;
            reset_dut();
            drive_bit(0);
            drive_bit(1);
            drive_bit(1);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Interrupted then valid sequence '010110'");
            test_num = test_num + 1;
            reset_dut();
            drive_bit(0);
            drive_bit(1);
            drive_bit(0);
            drive_bit(1);
            drive_bit(1);
            drive_bit(0);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Overlapping sequences '0110110'");
            test_num = test_num + 1;
            reset_dut();

            drive_bit(0); drive_bit(1); drive_bit(1); drive_bit(0);

            drive_bit(1); drive_bit(1); drive_bit(0);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: All zeros '0000'");
            test_num = test_num + 1;
            reset_dut();
            drive_bit(0); drive_bit(0); drive_bit(0); drive_bit(0);
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
        $dumpvars(0,in, out);
    end

endmodule
