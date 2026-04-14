`timescale 1ns/1ps

module sipo_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_in;
    wire [3:0] parallel_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sipo_shift_register dut (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .parallel_out(parallel_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        serial_in = 0;
        @(negedge clk);
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Shift sequence 1-0-1-0", test_num);
        reset_dut();

        @(negedge clk); serial_in = 1;
        @(negedge clk); serial_in = 0;
        @(negedge clk); serial_in = 1;
        @(negedge clk); serial_in = 0;

        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Shift sequence 1-1-1-1", test_num);
        reset_dut();

        @(negedge clk); serial_in = 1;
        @(negedge clk); serial_in = 1;
        @(negedge clk); serial_in = 1;
        @(negedge clk); serial_in = 1;

        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Shift sequence 0-0-0-0", test_num);
        reset_dut();

        @(negedge clk); serial_in = 0;
        @(negedge clk); serial_in = 0;
        @(negedge clk); serial_in = 0;
        @(negedge clk); serial_in = 0;

        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Shift sequence 1-1-0-0", test_num);
        reset_dut();

        @(negedge clk); serial_in = 1;
        @(negedge clk); serial_in = 1;
        @(negedge clk); serial_in = 0;
        @(negedge clk); serial_in = 0;

        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Shift sequence 0-0-1-1", test_num);
        reset_dut();

        @(negedge clk); serial_in = 0;
        @(negedge clk); serial_in = 0;
        @(negedge clk); serial_in = 1;
        @(negedge clk); serial_in = 1;

        @(posedge clk);
        #1;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sipo_shift_register Testbench");
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
        input [3:0] expected_parallel_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h",
                         parallel_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h",
                         expected_parallel_out);
                $display("  Got:      parallel_out=%h",
                         parallel_out);
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
        $dumpvars(0,clk, reset, serial_in, parallel_out);
    end

endmodule
