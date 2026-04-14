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
        #1 reset = 0;
        @(posedge clock);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset State Check");
        reset_dut();

        #1;


        check_outputs(8'h00, 1'b1, 1'b0);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Single Push-Pop");
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

    task testcase003;

    integer i;
    begin
        $display("Running testcase003: Fill Stack (Full Check)");
        reset_dut();

        for (i = 1; i <= 8; i = i + 1) begin
            DATAIN = i;
            wn = 1;
            @(posedge clock);
            #1 wn = 0;
        end


        #1;



        check_outputs(8'h00, 1'b0, 1'b1);
    end
        endtask

    task testcase004;

    integer i;
    begin
        $display("Running testcase004: LIFO Order Verification");
        reset_dut();


        for (i = 1; i <= 8; i = i + 1) begin
            DATAIN = i;
            wn = 1;
            @(posedge clock);
            #1 wn = 0;
        end


        for (i = 1; i <= 8; i = i + 1) begin
            rn = 1;
            @(posedge clock);
            #1 rn = 0;
        end


        #1;



        check_outputs(8'h01, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        $display("Running testcase005: Overflow Test");
        reset_dut();


        for (i = 1; i <= 9; i = i + 1) begin
            DATAIN = i;
            wn = 1;
            @(posedge clock);
            #1 wn = 0;
        end


        rn = 1;
        @(posedge clock);
        #1 rn = 0;

        #1;


        check_outputs(8'h08, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Underflow Test");
        reset_dut();


        rn = 1;
        @(posedge clock);
        #1 rn = 0;

        #1;


        check_outputs(8'h00, 1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        $display("Running testcase007: Interleaved Operations");
        reset_dut();


        DATAIN = 8'h11; wn = 1; @(posedge clock); #1;
        DATAIN = 8'h22; wn = 1; @(posedge clock); #1 wn = 0;


        rn = 1; @(posedge clock); #1 rn = 0;


        DATAIN = 8'h33; wn = 1; @(posedge clock); #1 wn = 0;


        rn = 1; @(posedge clock); #1 rn = 0;


        rn = 1; @(posedge clock); #1 rn = 0;

        #1;


        check_outputs(8'h11, 1'b1, 1'b0);
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
