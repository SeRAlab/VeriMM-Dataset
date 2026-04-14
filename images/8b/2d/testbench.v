`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] DATAIN;
    reg clock;
    reg reset;
    reg rn;
    reg wn;
    wire [7:0] DATAOUT;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATAIN(DATAIN),
        .clock(clock),
        .reset(reset),
        .rn(rn),
        .wn(wn),
        .DATAOUT(DATAOUT),
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
            reset = 1;
            wn = 0;
            rn = 0;
            DATAIN = 0;
            @(posedge clock);
            #1;
            reset = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Write and Read", test_num);
            reset_dut();


            DATAIN = 8'hA5;
            wn = 1;
            @(posedge clock);
            #1 wn = 0;


            rn = 1;
            @(posedge clock);
            #1 rn = 0;


            #1;



            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill FIFO to Full", test_num);
            reset_dut();


            wn = 1;
            for (i = 1; i <= 8; i = i + 1) begin
                DATAIN = i;
                @(posedge clock);
                #1;
            end
            wn = 0;


            #1;



            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill then Empty FIFO", test_num);
            reset_dut();


            wn = 1;
            for (i = 1; i <= 8; i = i + 1) begin
                DATAIN = i;
                @(posedge clock);
                #1;
            end
            wn = 0;


            rn = 1;
            for (i = 1; i <= 8; i = i + 1) begin
                @(posedge clock);
                #1;
            end
            rn = 0;


            #1;



            check_outputs(8'h08, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow Prevention", test_num);
            reset_dut();


            wn = 1;
            for (i = 1; i <= 8; i = i + 1) begin
                DATAIN = i;
                @(posedge clock);
                #1;
            end

            DATAIN = 8'h99;
            @(posedge clock);
            #1 wn = 0;


            rn = 1;
            @(posedge clock);
            #1 rn = 0;


            #1;



            check_outputs(8'h01, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Underflow Check (Read from Empty)", test_num);
            reset_dut();


            rn = 1;
            @(posedge clock);
            #1 rn = 0;


            #1;



            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pointer Wrapping Logic", test_num);
            reset_dut();


            wn = 1;
            for (i = 1; i <= 5; i = i + 1) begin
                DATAIN = i;
                @(posedge clock);
                #1;
            end
            wn = 0;


            rn = 1;
            repeat(3) @(posedge clock);
            #1 rn = 0;



            wn = 1;
            for (i = 6; i <= 10; i = i + 1) begin
                DATAIN = i;
                @(posedge clock);
                #1;
            end
            wn = 0;


            rn = 1;
            @(posedge clock);
            #1 rn = 0;

            #1;


            check_outputs(8'h04, 1'b0, 1'b0);
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
        input [7:0] expected_DATAOUT;
        input expected_empty;
        input expected_full;
        begin
            if (expected_DATAOUT === (expected_DATAOUT ^ DATAOUT ^ expected_DATAOUT) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: DATAOUT=%h, empty=%b, full=%b",
                         DATAOUT, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATAOUT=%h, empty=%b, full=%b",
                         expected_DATAOUT, expected_empty, expected_full);
                $display("  Got:      DATAOUT=%h, empty=%b, full=%b",
                         DATAOUT, empty, full);
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
        $dumpvars(0,DATAIN, clock, reset, rn, wn, DATAOUT, empty, full);
    end

endmodule
