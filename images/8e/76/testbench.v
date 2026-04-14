`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] DATAIN;
    reg [1:0] MODE;
    reg clock;
    reg reset;
    wire [3:0] DATAOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATAIN(DATAIN),
        .MODE(MODE),
        .clock(clock),
        .reset(reset),
        .DATAOUT(DATAOUT)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        reset = 1;
        MODE = MODE_HOLD;
        DATAIN = 4'b0000;
        @(posedge clock);
        #1 reset = 0;
        @(posedge clock);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Verifying Reset", test_num);
        reset_dut();

        #1;


        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Parallel Load (1010)", test_num);
        reset_dut();
        DATAIN = 4'b1010;
        MODE = MODE_LOAD;
        @(posedge clock);
        #1;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Parallel Load then Right Shift", test_num);
        reset_dut();

        DATAIN = 4'b1111;
        MODE = MODE_LOAD;
        @(posedge clock);

        #1 MODE = MODE_SRIGHT;
        @(posedge clock);
        #1;
        #1;

        check_outputs(4'b0111);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Parallel Load then Left Shift", test_num);
        reset_dut();

        DATAIN = 4'b1111;
        MODE = MODE_LOAD;
        @(posedge clock);

        #1 MODE = MODE_SLEFT;
        @(posedge clock);
        #1;
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Verify Hold Mode", test_num);
        reset_dut();

        DATAIN = 4'b0101;
        MODE = MODE_LOAD;
        @(posedge clock);

        #1 MODE = MODE_HOLD;
        DATAIN = 4'b1111;
        @(posedge clock);
        @(posedge clock);
        #1;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Right Shift 4 times to clear", test_num);
        reset_dut();

        DATAIN = 4'b1111;
        MODE = MODE_LOAD;
        @(posedge clock);

        #1 MODE = MODE_SRIGHT;
        repeat(4) @(posedge clock);
        #1;
        #1;

        check_outputs(4'b0000);
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
        input [3:0] expected_DATAOUT;
        begin
            if (expected_DATAOUT === (expected_DATAOUT ^ DATAOUT ^ expected_DATAOUT)) begin
                $display("PASS");
                $display("  Outputs: DATAOUT=%h",
                         DATAOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATAOUT=%h",
                         expected_DATAOUT);
                $display("  Got:      DATAOUT=%h",
                         DATAOUT);
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
        $dumpvars(0,DATAIN, MODE, clock, reset, DATAOUT);
    end

endmodule
