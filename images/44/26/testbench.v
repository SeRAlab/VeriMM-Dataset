`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aclr;
    reg clock;
    reg [7:0] data;
    reg rdreq;
    reg wrreq;
    wire almost_full;
    wire empty;
    wire full;
    wire [7:0] q;
    wire [3:0] usedw;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .aclr(aclr),
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
            aclr = 1;
            wrreq = 0;
            rdreq = 0;
            data = 8'h00;
            repeat (2) @(posedge clock);
            #1 aclr = 0;
            repeat (2) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning testcase001: Initial Reset State");
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 8'hxx, 4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning testcase002: Single Write and Read");
            reset_dut();


            @(posedge clock);
            #1; wrreq = 1; data = 8'hA5;
            @(posedge clock);
            #1; wrreq = 0;


            repeat(1) @(posedge clock);


            #1; rdreq = 1;
            @(posedge clock);
            #1; rdreq = 0;



            #1;




            check_outputs(1'b0, 1'b1, 1'b0, 8'hA5, 4'h0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("\nRunning testcase003: Almost Full Threshold (14 entries)");
            reset_dut();

            for (i = 0; i < 14; i = i + 1) begin
                @(posedge clock);
                #1; wrreq = 1; data = i[7:0];
            end
            @(posedge clock);
            #1; wrreq = 0;

            repeat(1) @(posedge clock);

            #1;


            check_outputs(1'b1, 1'b0, 1'b0, 8'h00, 4'hE);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("\nRunning testcase004: Full and Overflow Prevention");
            reset_dut();


            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clock);
                #1; wrreq = 1; data = i[7:0];
            end
            @(posedge clock);

            #1; data = 8'hFF;
            @(posedge clock);
            #1; wrreq = 0;

            repeat(1) @(posedge clock);



            #1;




            check_outputs(1'b1, 1'b0, 1'b1, 8'h00, 4'h0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            $display("\nRunning testcase005: Empty and Underflow Prevention");
            reset_dut();


            @(posedge clock);
            #1; wrreq = 1; data = 8'h11;
            @(posedge clock);
            #1; wrreq = 1; data = 8'h22;
            @(posedge clock);
            #1; wrreq = 0;


            repeat(1) @(posedge clock);
            #1; rdreq = 1;
            @(posedge clock);
            @(posedge clock);
            @(posedge clock);
            #1; rdreq = 0;

            repeat(1) @(posedge clock);

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 8'h22, 4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning testcase006: Asynchronous Clear");
            reset_dut();


            @(posedge clock);
            #1; wrreq = 1; data = 8'h55;
            @(posedge clock);
            #1; wrreq = 1; data = 8'h66;
            @(posedge clock);
            #1; wrreq = 0;


            #3 aclr = 1;
            #10 aclr = 0;

            repeat(2) @(posedge clock);

            #1;


            check_outputs(1'b0, 1'b1, 1'b0, 8'hxx, 4'h0);
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
        input expected_almost_full;
        input expected_empty;
        input expected_full;
        input [7:0] expected_q;
        input [3:0] expected_usedw;
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
        $dumpvars(0,aclr, clock, data, rdreq, wrreq, almost_full, empty, full, q, usedw);
    end

endmodule
