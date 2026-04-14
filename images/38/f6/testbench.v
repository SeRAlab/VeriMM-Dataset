`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    wire [7:0] q;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .q(q),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin


        data_in = 8'h00;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Parallel Load 8'hA5", test_num);
        reset_dut();
        data_in = 8'hA5;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;

        #1;


        check_outputs(8'hA5, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Single Right Shift from 8'h02", test_num);
        reset_dut();

        data_in = 8'h02;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;

        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h01, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Four Right Shifts from 8'hF0", test_num);
        reset_dut();

        data_in = 8'hF0;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;

        repeat(4) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h0F, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Shift MSB (0x80) to LSB position (7 shifts)", test_num);
        reset_dut();

        data_in = 8'h80;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;

        repeat(7) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h01, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Full shift out of 8'hFF", test_num);
        reset_dut();

        data_in = 8'hFF;
        load = 1;
        @(posedge clk);
        #1;
        load = 0;

        repeat(8) @(posedge clk);
        #1;
        #1;

        check_outputs(8'h00, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [7:0] expected_q;
        input expected_serial_out;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: q=%h, serial_out=%b",
                         q, serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, serial_out=%b",
                         expected_q, expected_serial_out);
                $display("  Got:      q=%h, serial_out=%b",
                         q, serial_out);
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
        $dumpvars(0,clk, data_in, load, q, serial_out);
    end

endmodule
