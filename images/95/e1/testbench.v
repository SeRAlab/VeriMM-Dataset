`timescale 1ns/1ps

module shift_reg_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_in;
    reg rst;
    reg serial_in;
    reg shift;
    wire [7:0] parallel_out;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_reg_8bit dut (
        .clk(clk),
        .load(load),
        .parallel_in(parallel_in),
        .rst(rst),
        .serial_in(serial_in),
        .shift(shift),
        .parallel_out(parallel_out),
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
        load = 0;
        shift = 0;
        parallel_in = 8'h0;
        serial_in = 0;
        @(posedge clk);
        #1 rst = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Check", test_num);
        reset_dut();

        @(posedge clk);
        #1 #1;
 check_outputs(8'h00, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Parallel Load 0xA5", test_num);
        reset_dut();
        parallel_in = 8'hA5;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        #1;


        check_outputs(8'hA5, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Shift Left (0x55 -> 0xAA)", test_num);
        reset_dut();

        parallel_in = 8'h55;
        load = 1;
        @(posedge clk);
        #1 load = 0;

        shift = 1;
        serial_in = 0;
        @(posedge clk);
        #1 shift = 0;

        #1;


        check_outputs(8'hAA, 1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: 8-bit Serial Infill", test_num);
        reset_dut();
        shift = 1;
        serial_in = 1;
        repeat(8) @(posedge clk);
        #1 shift = 0;

        #1;


        check_outputs(8'hFF, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Priority Check (Load vs Shift)", test_num);
        reset_dut();
        parallel_in = 8'hCC;
        load = 1;
        shift = 1;
        serial_in = 0;
        @(posedge clk);
        #1 load = 0; shift = 0;

        #1;


        check_outputs(8'hCC, 1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Hold Logic Check", test_num);
        reset_dut();
        parallel_in = 8'h12;
        load = 1;
        @(posedge clk);
        #1 load = 0;
        repeat(4) @(posedge clk);
        #1 #1;
 check_outputs(8'h12, 0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_reg_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_parallel_out;
        input expected_serial_out;
        begin
            if (expected_parallel_out === (expected_parallel_out ^ parallel_out ^ expected_parallel_out) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: parallel_out=%h, serial_out=%b",
                         parallel_out, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parallel_out=%h, serial_out=%b",
                         expected_parallel_out, expected_serial_out);
                $display("  Got:      parallel_out=%h, serial_out=%b",
                         parallel_out, serial_out);
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
        $dumpvars(0,clk, load, parallel_in, rst, serial_in, shift, parallel_out, serial_out);
    end

endmodule
