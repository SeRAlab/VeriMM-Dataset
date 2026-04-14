`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [10:0] data_in;
    reg read;
    reg reset;
    reg write;
    wire [10:0] data_out;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data_in(data_in),
        .read(read),
        .reset(reset),
        .write(write),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            @(posedge clock);
            reset = 1;
            write = 0;
            read = 0;
            data_in = 0;
            repeat (2) @(posedge clock);
            reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(data_out, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Single Word Write/Read", test_num);
            reset_dut();


            data_in = 11'h123;
            write = 1;
            @(posedge clock);
            write = 0;
            @(posedge clock);


            read = 1;
            @(posedge clock);
            read = 0;
            @(posedge clock);


            #1;



            check_outputs(11'h123, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: FIFO Sequence Check", test_num);
            reset_dut();


            data_in = 11'hAAA; write = 1; @(posedge clock);

            data_in = 11'hBBB; write = 1; @(posedge clock);
            write = 0;
            @(posedge clock);


            read = 1; @(posedge clock);
            read = 0; @(posedge clock);


            #1;



            check_outputs(11'hBBB, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nTestcase %0d: Fill until Full", test_num);
            reset_dut();


            for (i = 0; i < 32 && !full; i = i + 1) begin
                data_in = i[10:0];
                write = 1;
                @(posedge clock);
            end
            write = 0;
            @(posedge clock);


            #1;



            check_outputs(data_out, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        reg [10:0] last_val;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Full to Empty Cycle", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                data_in = i + 11'h100;
                write = 1;
                @(posedge clock);
            end
            write = 0;


            read = 1;
            for (i = 0; i < 8; i = i + 1) begin
                last_val = data_out;
                @(posedge clock);
            end
            read = 0;
            @(posedge clock);


            #1;



            check_outputs(last_val, 1'b1, 1'b0);
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
        input [10:0] expected_data_out;
        input expected_empty;
        input expected_full;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, empty=%b, full=%b",
                         expected_data_out, expected_empty, expected_full);
                $display("  Got:      data_out=%h, empty=%b, full=%b",
                         data_out, empty, full);
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
        $dumpvars(0,clock, data_in, read, reset, write, data_out, empty, full);
    end

endmodule
