`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg direction;
    reg load;
    reg reset;
    reg serial_in;
    wire [3:0] serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .direction(direction),
        .load(load),
        .reset(reset),
        .serial_in(serial_in),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        load = 0;
        direction = 0;
        serial_in = 0;
        @(posedge clk);
        #1 reset = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase 001: System Reset");
        reset_dut();
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase 002: Serial Load 1011");
        reset_dut();

        load = 1; serial_in = 1; @(posedge clk);
        #1 serial_in = 0; @(posedge clk);
        #1 serial_in = 1; @(posedge clk);
        #1 serial_in = 1; @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase 003: Circular Shift Left (1011 -> 0111)");
        reset_dut();

        load = 1; serial_in = 1; @(posedge clk);
        #1 serial_in = 0; @(posedge clk);
        #1 serial_in = 1; @(posedge clk);
        #1 serial_in = 1; @(posedge clk);

        #1 load = 0; direction = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase 004: Circular Shift Right (1011 -> 1101)");
        reset_dut();

        load = 1; serial_in = 1; @(posedge clk);
        #1 serial_in = 0; @(posedge clk);
        #1 serial_in = 1; @(posedge clk);
        #1 serial_in = 1; @(posedge clk);

        #1 load = 0; direction = 0; @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1101);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase 005: Reset Priority over Load");
        reset_dut();
        load = 1; serial_in = 1; @(posedge clk);
        #1 reset = 1; load = 1; serial_in = 1; @(posedge clk);
        #1 reset = 0; load = 0;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase 006: Load Priority over Shifting");
        reset_dut();

        load = 1; serial_in = 1; @(posedge clk);
        #1 serial_in = 0; @(posedge clk);
        #1 serial_in = 1; @(posedge clk);
        #1 serial_in = 1; @(posedge clk);


        #1 load = 1; serial_in = 0; direction = 1; @(posedge clk);
        #1 load = 0;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase 007: Multiple Rotations (1000 -> 0001 -> 0010)");
        reset_dut();
        load = 1; serial_in = 1; @(posedge clk);
        #1 serial_in = 0; @(posedge clk);
        #1 serial_in = 0; @(posedge clk);
        #1 serial_in = 0; @(posedge clk);
        #1 load = 0; direction = 1; @(posedge clk);
        #1 direction = 1; @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0010);
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
        input [3:0] expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%h",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%h",
                         expected_serial_out);
                $display("  Got:      serial_out=%h",
                         serial_out);
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
        $dumpvars(0,clk, direction, load, reset, serial_in, serial_out);
    end

endmodule
