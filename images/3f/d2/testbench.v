`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] data_in;
    reg load_enable;
    reg reset;
    reg shift_enable;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load_enable(load_enable),
        .reset(reset),
        .shift_enable(shift_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        @(negedge clk);
        reset = 1;
        load_enable = 0;
        shift_enable = 0;
        data_in = 16'h0000;
        @(negedge clk);
        reset = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Synchronous Reset");
        reset_dut();
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Parallel Load");
        reset_dut();
        @(negedge clk);
        load_enable = 1;
        data_in = 16'hA5A5;
        @(negedge clk);
        load_enable = 0;
        #1;

        check_outputs(16'hA5A5);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Single Shift (Fill LSB with 1)");
        reset_dut();
        @(negedge clk);
        shift_enable = 1;
        data_in = 16'h0001;
        @(negedge clk);
        shift_enable = 0;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Multiple Shifts");
        reset_dut();
        @(negedge clk);
        load_enable = 1;
        data_in = 16'h0001;
        @(negedge clk);
        load_enable = 0;
        shift_enable = 1;
        data_in = 16'h0000;
        repeat(4) @(negedge clk);
        shift_enable = 0;
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Reset Priority over Load");
        reset_dut();
        @(negedge clk);
        reset = 1;
        load_enable = 1;
        data_in = 16'hFFFF;
        @(negedge clk);
        reset = 0;
        load_enable = 0;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Load Priority over Shift");
        reset_dut();
        @(negedge clk);
        load_enable = 1;
        shift_enable = 1;
        data_in = 16'h1234;
        @(negedge clk);
        load_enable = 0;
        shift_enable = 0;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase007;

    integer i;
    begin
        $display("Testcase 007: Fill Entire Register via 16 Shifts");
        reset_dut();
        @(negedge clk);
        shift_enable = 1;
        data_in = 16'h0001;
        for(i=0; i<16; i=i+1) begin
            @(negedge clk);
        end
        shift_enable = 0;
        #1;

        check_outputs(16'hFFFF);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, load_enable, reset, shift_enable, data_out);
    end

endmodule
