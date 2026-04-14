`timescale 1ns/1ps

module reg16_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [15:0] data_in;
    reg load;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg16 dut (
        .clear(clear),
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        clear = 1;
        load = 0;
        data_in = 16'h0000;
        @(posedge clk);
        #1;
        clear = 0;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: Basic Synchronous Clear");
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Load Value 0xABCD");
        test_num = 2;
        reset_dut();
        @(negedge clk);
        load = 1;
        data_in = 16'hABCD;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Data Retention (load=0, clear=0)");
        test_num = 3;
        reset_dut();

        @(negedge clk);
        load = 1;
        data_in = 16'h1234;
        @(posedge clk);
        #1;

        @(negedge clk);
        load = 0;
        data_in = 16'hFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Priority Test (clear and load both high)");
        test_num = 4;
        reset_dut();
        @(negedge clk);
        load = 1;
        clear = 1;
        data_in = 16'h5555;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'h0000);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Load 0xFFFF");
        test_num = 5;
        reset_dut();
        @(negedge clk);
        load = 1;
        data_in = 16'hFFFF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Load followed by Clear");
        test_num = 6;
        reset_dut();

        @(negedge clk);
        load = 1;
        data_in = 16'hAAAA;
        @(posedge clk);
        #1;

        @(negedge clk);
        load = 0;
        clear = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg16 Testbench");
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
        $dumpvars(0,clear, clk, data_in, load, data_out);
    end

endmodule
