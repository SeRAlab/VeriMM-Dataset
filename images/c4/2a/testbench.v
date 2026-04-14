`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] data_in;
    reg reset;
    reg shift_left;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clock(clock),
        .data_in(data_in),
        .reset(reset),
        .shift_left(shift_left),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        data_in = 4'b0000;
        shift_left = 0;
        @(posedge clock);
        #1 reset = 0;

        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase 001: Reset Check");
        reset_dut();
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase 002: Shift Left 4x");
        reset_dut();

        data_in = 4'b0001; shift_left = 1; @(posedge clock);
        #1 data_in = 4'b0001; shift_left = 1; @(posedge clock);
        #1 data_in = 4'b0000; shift_left = 1; @(posedge clock);
        #1 data_in = 4'b0001; shift_left = 1; @(posedge clock);

        #1 #1;
 check_outputs(4'b1101);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase 003: Shift Right 4x");
        reset_dut();

        data_in = 4'b0001; shift_left = 0; @(posedge clock);
        #1 data_in = 4'b0001; shift_left = 0; @(posedge clock);
        #1 data_in = 4'b0000; shift_left = 0; @(posedge clock);
        #1 data_in = 4'b0001; shift_left = 0; @(posedge clock);

        #1 #1;
 check_outputs(4'b1011);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase 004: Mixed Directions");
        reset_dut();

        data_in = 4'b0001; shift_left = 1; @(posedge clock);
        #1 data_in = 4'b0001; shift_left = 1; @(posedge clock);
        #1 data_in = 4'b0001; shift_left = 0; @(posedge clock);
        #1 data_in = 4'b0000; shift_left = 0; @(posedge clock);

        #1 #1;
 check_outputs(4'b0100);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase 005: Left Overflow");
        reset_dut();


        data_in = 4'b0001; shift_left = 1;
        repeat(4) @(posedge clock);


        #1 data_in = 4'b0000; shift_left = 1; @(posedge clock);

        #1 #1;
 check_outputs(4'b1110);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase 006: Bus Consistency");
        reset_dut();

        data_in = 4'b1111; shift_left = 1; @(posedge clock);
        #1 data_in = 4'b1110; shift_left = 1; @(posedge clock);

        #1 #1;
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
        $display("shift_register Testbench");
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
        input [3:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clock, data_in, reset, shift_left, data_out);
    end

endmodule
