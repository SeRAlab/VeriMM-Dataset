`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aclr;
    reg clock;
    reg [15:0] data;
    reg rdreq;
    reg wrreq;
    wire almost_empty;
    wire empty;
    wire full;
    wire [15:0] q;
    wire [9:0] usedw;

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
        .almost_empty(almost_empty),
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
        data = 16'h0;
        rdreq = 0;
        wrreq = 0;
        repeat (2) @(posedge clock);
        #1 aclr = 0;
        repeat (2) @(posedge clock);
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Initial state check", test_num);
        reset_dut();

        #1;


        check_outputs(1'b1, 1'b1, 1'b0, 16'hzzzz, 10'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Single Write then Read", test_num);
        reset_dut();


        @(posedge clock);
        #1 wrreq = 1; data = 16'hABCD;
        @(posedge clock);
        #1 wrreq = 0;


        @(posedge clock);
        #1 rdreq = 1;
        @(posedge clock);
        #1 rdreq = 0;


        #1;



        check_outputs(1'b1, 1'b1, 1'b0, 16'hABCD, 10'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Fill to Full capacity", test_num);
        reset_dut();

        for (i = 0; i < 1024; i = i + 1) begin
            @(posedge clock);
            #1 wrreq = 1; data = i[15:0];
        end
        @(posedge clock);
        #1 wrreq = 0;



        #1;




        check_outputs(1'b0, 1'b0, 1'b1, 16'hzzzz, 10'bxxxxxxxxxx);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Burst Write/Read Data Integrity", test_num);
        reset_dut();


        for (i = 1; i <= 5; i = i + 1) begin
            @(posedge clock);
            #1 wrreq = 1; data = i;
        end
        @(posedge clock);
        #1 wrreq = 0;


        for (i = 1; i <= 5; i = i + 1) begin
            @(posedge clock);
            #1 rdreq = 1;
            @(posedge clock);
            #1 rdreq = 0;
        end


        #1;



        check_outputs(1'b1, 1'b1, 1'b0, 16'd5, 10'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Almost Empty functionality", test_num);
        reset_dut();


        for (i = 0; i < 10; i = i + 1) begin
            @(posedge clock);
            #1 wrreq = 1; data = 16'hFFFF;
        end
        @(posedge clock);
        #1 wrreq = 0;



        #1;




        check_outputs(1'b0, 1'b0, 1'b0, 16'hzzzz, 10'd10);
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
        input expected_almost_empty;
        input expected_empty;
        input expected_full;
        input [15:0] expected_q;
        input [9:0] expected_usedw;
        begin
            if (expected_almost_empty === (expected_almost_empty ^ almost_empty ^ expected_almost_empty) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_usedw === (expected_usedw ^ usedw ^ expected_usedw)) begin
                $display("PASS");
                $display("  Outputs: almost_empty=%b, empty=%b, full=%b, q=%h, usedw=%h",
                         almost_empty, empty, full, q, usedw);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: almost_empty=%b, empty=%b, full=%b, q=%h, usedw=%h",
                         expected_almost_empty, expected_empty, expected_full, expected_q, expected_usedw);
                $display("  Got:      almost_empty=%b, empty=%b, full=%b, q=%h, usedw=%h",
                         almost_empty, empty, full, q, usedw);
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
        $dumpvars(0,aclr, clock, data, rdreq, wrreq, almost_empty, empty, full, q, usedw);
    end

endmodule
