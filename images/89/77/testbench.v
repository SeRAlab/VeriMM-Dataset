`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aclr;
    reg clock;
    reg [71:0] data;
    reg rdreq;
    reg wrreq;
    wire almost_full;
    wire empty;
    wire full;
    wire [71:0] q;

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
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

    begin
        aclr = 1;
        rdreq = 0;
        wrreq = 0;
        data = 0;
        #20;
        aclr = 0;
        #20;
        @(posedge clock);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 72'hxxxxxxxxxxxxxxxxxx);
    end
        endtask

    task testcase002;

    begin
        reset_dut();

        wrreq = 1;
        data = 72'hFEDCBA987654321012;
        @(posedge clock);
        #1;
        wrreq = 0;
        @(posedge clock);
        #1;

        rdreq = 1;
        @(posedge clock);
        #1;
        rdreq = 0;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 72'hFEDCBA987654321012);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        wrreq = 1;
        for (i = 0; i < 256; i = i + 1) begin
            data = i;
            @(posedge clock);
            #1;
        end
        wrreq = 0;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b1, 72'hxxxxxxxxxxxxxxxxxx);
    end
        endtask

    task testcase004;

    begin
        reset_dut();

        wrreq = 1;
        for (i = 0; i < 256; i = i + 1) begin
            data = i;
            @(posedge clock);
            #1;
        end
        wrreq = 0;

        rdreq = 1;
        for (i = 0; i < 256; i = i + 1) begin
            @(posedge clock);
            #1;
        end
        rdreq = 0;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 255);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        wrreq = 1;

        for (i = 0; i < 255; i = i + 1) begin
            data = i;
            @(posedge clock);
            #1;
        end
        wrreq = 0;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b0, 72'hxxxxxxxxxxxxxxxxxx);
    end
        endtask

    task testcase006;

    begin
        reset_dut();

        rdreq = 1;
        repeat(5) @(posedge clock);
        #1;
        rdreq = 0;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1'b0, 1'b1, 1'b0, 72'hxxxxxxxxxxxxxxxxxx);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        wrreq = 1;

        for (i = 0; i < 260; i = i + 1) begin
            data = i;
            @(posedge clock);
            #1;
        end
        wrreq = 0;
        @(posedge clock);
        #1;

        #1;


        check_outputs(1'b1, 1'b0, 1'b1, 72'hxxxxxxxxxxxxxxxxxx);
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
        input expected_almost_full;
        input expected_empty;
        input expected_full;
        input [71:0] expected_q;
        begin
            if (expected_almost_full === (expected_almost_full ^ almost_full ^ expected_almost_full) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: almost_full=%b, empty=%b, full=%b, q=%h",
                         almost_full, empty, full, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: almost_full=%b, empty=%b, full=%b, q=%h",
                         expected_almost_full, expected_empty, expected_full, expected_q);
                $display("  Got:      almost_full=%b, empty=%b, full=%b, q=%h",
                         almost_full, empty, full, q);
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
        $dumpvars(0,aclr, clock, data, rdreq, wrreq, almost_full, empty, full, q);
    end

endmodule
