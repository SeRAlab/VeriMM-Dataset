`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [71:0] data;
    reg rdreq;
    reg sclr;
    reg wrreq;
    wire empty;
    wire full;
    wire [71:0] q;
    wire [2:0] usedw;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .rdreq(rdreq),
        .sclr(sclr),
        .wrreq(wrreq),
        .empty(empty),
        .full(full),
        .q(q),
        .usedw(usedw)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            sclr = 1;
            wrreq = 0;
            rdreq = 0;
            data = 0;
            @(posedge clock);
            #1 sclr = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial State after Reset");
            reset_dut();

            #1;


            check_outputs(1'b1, 1'b0, 72'bx, 3'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Write");
            reset_dut();
            wrreq = 1;
            data = 72'hFEEDFACE_DEAFBEEF_01;
            @(posedge clock);
            #1 wrreq = 0;
            @(posedge clock);

            #1;


            check_outputs(1'b0, 1'b0, 72'bx, 3'd1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Fill FIFO (8 entries)");
            reset_dut();
            wrreq = 1;
            for (i = 0; i < 8; i = i + 1) begin
                data = i + 72'hA0000000;
                @(posedge clock);
            end
            #1 wrreq = 0;
            @(posedge clock);

            #1;


            check_outputs(1'b0, 1'b1, 72'bx, 3'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Data Integrity (Write then Read)");
            reset_dut();

            wrreq = 1;
            data = 72'hCAFE_CAFE_CAFE_CAFE_CA;
            @(posedge clock);
            #1 wrreq = 0;
            @(posedge clock);

            rdreq = 1;
            @(posedge clock);
            #1 rdreq = 0;
            @(posedge clock);

            #1;


            check_outputs(1'b1, 1'b0, 72'hCAFE_CAFE_CAFE_CAFE_CA, 3'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Simultaneous Read and Write");
            reset_dut();

            wrreq = 1;
            data = 72'h1111;
            @(posedge clock);
            #1;

            wrreq = 1;
            rdreq = 1;
            data = 72'h2222;
            @(posedge clock);
            #1 wrreq = 0; rdreq = 0;
            @(posedge clock);


            #1;



            check_outputs(1'b0, 1'b0, 72'h1111, 3'd1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Synchronous Clear (sclr) during operation");
            reset_dut();

            wrreq = 1;
            data = 72'h1; @(posedge clock);
            data = 72'h2; @(posedge clock);
            data = 72'h3; @(posedge clock);
            data = 72'h4; @(posedge clock);
            #1 wrreq = 0;

            sclr = 1;
            @(posedge clock);
            #1 sclr = 0;
            @(posedge clock);

            #1;


            check_outputs(1'b1, 1'b0, 72'bx, 3'd0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Read Empty FIFO");
            reset_dut();
            rdreq = 1;
            @(posedge clock);
            #1 rdreq = 0;
            @(posedge clock);

            #1;


            check_outputs(1'b1, 1'b0, 72'bx, 3'd0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: FIFO Order Verification");
            reset_dut();

            wrreq = 1;
            data = 72'hAAAA; @(posedge clock);
            data = 72'hBBBB; @(posedge clock);
            data = 72'hCCCC; @(posedge clock);
            #1 wrreq = 0;

            rdreq = 1; @(posedge clock);
            @(posedge clock);
            #1 rdreq = 0;
            @(posedge clock);

            #1;


            check_outputs(1'b0, 1'b0, 72'hBBBB, 3'd1);
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
        testcase008();
        
        
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
        input expected_empty;
        input expected_full;
        input [71:0] expected_q;
        input [2:0] expected_usedw;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_usedw === (expected_usedw ^ usedw ^ expected_usedw)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, q=%h, usedw=%h",
                         empty, full, q, usedw);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, q=%h, usedw=%h",
                         expected_empty, expected_full, expected_q, expected_usedw);
                $display("  Got:      empty=%b, full=%b, q=%h, usedw=%h",
                         empty, full, q, usedw);
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
        $dumpvars(0,clock, data, rdreq, sclr, wrreq, empty, full, q, usedw);
    end

endmodule
