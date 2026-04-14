`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [13:0] data;
    reg rdreq;
    reg wrreq;
    wire almost_full;
    wire empty;
    wire full;
    wire [13:0] q;
    wire [7:0] usedw;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .rdreq(rdreq),
        .wrreq(wrreq),
        .almost_full(almost_full),
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
            data = 14'd0;
            rdreq = 0;
            wrreq = 0;
            @(posedge clock);

            while (!empty) begin
                rdreq = 1;
                @(posedge clock);
            end
            rdreq = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            wrreq = 1;
            data = 14'h1234;
            @(posedge clock);
            wrreq = 0;
            @(posedge clock);


            rdreq = 1;
            @(posedge clock);
            rdreq = 0;
            @(posedge clock);

            $display("Testcase 001: Basic Write/Read");
            #1;

            check_outputs(1'b0, 1'b1, 1'b0, 14'h1234, 8'd0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            reset_dut();


            for (i = 0; i < 256; i = i + 1) begin
                wrreq = 1;
                data = i[13:0];
                @(posedge clock);
            end
            wrreq = 0;
            @(posedge clock);

            $display("Testcase 002: Fill to Full");

            #1;


            check_outputs(1'b1, 1'b0, 1'b1, q, 8'd0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();


            for (i = 0; i < 256; i = i + 1) begin
                wrreq = 1; data = i[13:0];
                @(posedge clock);
            end
            wrreq = 0;


            for (i = 0; i < 256; i = i + 1) begin
                rdreq = 1;
                @(posedge clock);
            end
            rdreq = 0;
            @(posedge clock);

            $display("Testcase 003: Drain to Empty");

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 14'd255, 8'd0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();


            for (i = 0; i < 200; i = i + 1) begin
                wrreq = 1; data = i[13:0]; @(posedge clock);
            end
            wrreq = 0;


            for (i = 0; i < 200; i = i + 1) begin
                rdreq = 1; @(posedge clock);
            end
            rdreq = 0;


            for (i = 0; i < 100; i = i + 1) begin
                wrreq = 1; data = 14'h3FFF; @(posedge clock);
            end
            wrreq = 0;
            @(posedge clock);

            $display("Testcase 004: Wrap-around check");
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 14'h3FFF, 8'd100);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();


            for (i = 0; i < 10; i = i + 1) begin
                wrreq = 1; data = i[13:0]; @(posedge clock);
            end
            wrreq = 0;
            @(posedge clock);



            wrreq = 1; data = 14'h2AAA;
            rdreq = 1;
            @(posedge clock);
            wrreq = 0;
            rdreq = 0;
            @(posedge clock);

            $display("Testcase 005: Simultaneous Read/Write");
            #1;

            check_outputs(1'b0, 1'b0, 1'b0, 14'h0000, 8'd10);
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
        input expected_almost_full;
        input expected_empty;
        input expected_full;
        input [13:0] expected_q;
        input [7:0] expected_usedw;
        begin
            if (expected_almost_full === (expected_almost_full ^ almost_full ^ expected_almost_full) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_usedw === (expected_usedw ^ usedw ^ expected_usedw)) begin
                $display("PASS");
                $display("  Outputs: almost_full=%b, empty=%b, full=%b, q=%h, usedw=%h",
                         almost_full, empty, full, q, usedw);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: almost_full=%b, empty=%b, full=%b, q=%h, usedw=%h",
                         expected_almost_full, expected_empty, expected_full, expected_q, expected_usedw);
                $display("  Got:      almost_full=%b, empty=%b, full=%b, q=%h, usedw=%h",
                         almost_full, empty, full, q, usedw);
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
        $dumpvars(0,clock, data, rdreq, wrreq, almost_full, empty, full, q, usedw);
    end

endmodule
