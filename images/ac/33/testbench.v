`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aclr;
    reg clock;
    reg [29:0] data;
    reg rdreq;
    reg wrreq;
    wire empty;
    wire full;
    wire [29:0] q;
    wire [4:0] usedw;

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
            rdreq = 0;
            wrreq = 0;
            data = 0;
            #20;
            aclr = 0;
            #20;
        end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Initial Reset State", test_num);
        reset_dut();
        @(negedge clock);

        #1;


        check_outputs(1'b1, 1'b0, 30'bx, 5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Single Write then Read", test_num);
        reset_dut();
        @(posedge clock);
        wrreq = 1;
        data = 30'h12345678;
        @(posedge clock);
        wrreq = 0;
        rdreq = 1;
        @(posedge clock);
        rdreq = 0;
        @(negedge clock);

        #1;


        check_outputs(1'b1, 1'b0, 30'h12345678, 5'd0);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = 3;
        $display("Testcase %03d: Fill to Full (32 entries)", test_num);
        reset_dut();
        for (i = 0; i < 32; i = i + 1) begin
            @(posedge clock);
            wrreq = 1;
            data = i + 1;
        end
        @(posedge clock);
        wrreq = 0;
        @(negedge clock);

        #1;


        check_outputs(1'b0, 1'b1, 30'bx, 5'd0);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("Testcase %03d: Fill and Empty (Data Integrity)", test_num);
        reset_dut();

        for (i = 0; i < 32; i = i + 1) begin
            @(posedge clock);
            wrreq = 1;
            data = i;
        end
        @(posedge clock);
        wrreq = 0;

        for (i = 0; i < 32; i = i + 1) begin
            @(posedge clock);
            rdreq = 1;
        end
        @(posedge clock);
        rdreq = 0;
        @(negedge clock);

        #1;


        check_outputs(1'b1, 1'b0, 30'd31, 5'd0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("Testcase %03d: Partial Fill (15 entries)", test_num);
        reset_dut();
        for (i = 0; i < 15; i = i + 1) begin
            @(posedge clock);
            wrreq = 1;
            data = 30'hAAA + i;
        end
        @(posedge clock);
        wrreq = 0;
        @(negedge clock);

        #1;


        check_outputs(1'b0, 1'b0, 30'bx, 5'd15);
    end
        endtask

    task testcase006;

    integer i;
    begin
        test_num = 6;
        $display("Testcase %03d: Overflow Test", test_num);
        reset_dut();

        for (i = 0; i < 35; i = i + 1) begin
            @(posedge clock);
            wrreq = 1;
            data = i;
        end
        @(posedge clock);
        wrreq = 0;
        @(negedge clock);

        #1;


        check_outputs(1'b0, 1'b1, 30'bx, 5'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Underflow Test", test_num);
        reset_dut();
        @(posedge clock);
        rdreq = 1;
        @(posedge clock);
        rdreq = 0;
        @(negedge clock);

        #1;


        check_outputs(1'b1, 1'b0, 30'bx, 5'd0);
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
        input expected_empty;
        input expected_full;
        input [29:0] expected_q;
        input [4:0] expected_usedw;
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
        $dumpvars(0,aclr, clock, data, rdreq, wrreq, empty, full, q, usedw);
    end

endmodule
