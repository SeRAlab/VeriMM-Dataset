`timescale 1ns/1ps

module siso_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg serial_in;
    wire [4:0] serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    siso_shift_register dut (
        .clk(clk),
        .rst(rst),
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
            rst = 1;
            serial_in = 0;
            @(posedge clk);
            #1 rst = 0;
            $display("DUT Reset at time %t", $time);
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Shifting in all ones (11111)");
            reset_dut();
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(5'b11111);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Shifting alternating pattern (10101)");
            reset_dut();
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(5'b10101);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Shifting single pulse (10000)");
            reset_dut();
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(5'b10000);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Overflow Test (6 shifts: 101101)");
            reset_dut();
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(5'b01101);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: All Zeros Shift");
            reset_dut();

            @(negedge clk) serial_in = 1;
            @(negedge clk) serial_in = 1;
            reset_dut();
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 0;
            @(negedge clk) serial_in = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(5'b00000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("siso_shift_register Testbench");
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
        input [4:0] expected_serial_out;
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
        $dumpvars(0,clk, rst, serial_in, serial_out);
    end

endmodule
