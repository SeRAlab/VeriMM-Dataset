`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] data;
    reg rdreq;
    reg wrreq;
    wire empty;
    wire full;
    wire [31:0] q;

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
            rdreq = 0;
            wrreq = 0;
            data = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Initial State Check");
            reset_dut();

            #1;


            check_outputs(1, 0, q);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Write and Read");
            reset_dut();


            data = 32'hABCD_1234;
            wrreq = 1;
            @(posedge clock);
            wrreq = 0;
            @(posedge clock);


            rdreq = 1;
            @(posedge clock);
            rdreq = 0;
            @(posedge clock);


            #1;



            check_outputs(1, 0, 32'hABCD_1234);
        end
        endtask

    task testcase003;

        integer i;
        begin
            $display("Testcase 003: Fill to Capacity");
            reset_dut();

            for (i = 0; i < 1024; i = i + 1) begin
                data = i;
                wrreq = 1;
                @(posedge clock);
            end
            wrreq = 0;
            @(posedge clock);


            #1;



            check_outputs(0, 1, q);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Testcase 004: Fill then Empty Completely");
            reset_dut();


            for (i = 0; i < 1024; i = i + 1) begin
                data = i + 100;
                wrreq = 1;
                @(posedge clock);
            end
            wrreq = 0;


            for (i = 0; i < 1024; i = i + 1) begin
                rdreq = 1;
                @(posedge clock);
            end
            rdreq = 0;
            @(posedge clock);


            #1;



            check_outputs(1, 0, 1123);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: FIFO Order Verification");
            reset_dut();


            data = 32'h1111_1111; wrreq = 1; @(posedge clock);
            data = 32'h2222_2222; wrreq = 1; @(posedge clock);
            wrreq = 0;


            rdreq = 1; @(posedge clock);
            rdreq = 0; @(posedge clock);


            #1;



            check_outputs(0, 0, 32'h1111_1111);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Testcase 006: Overflow Protection");
            reset_dut();


            for (i = 0; i < 1025; i = i + 1) begin
                data = (i == 0) ? 32'hFEED_FACE : 32'hEEEE_EEEE;
                wrreq = 1;
                @(posedge clock);
            end
            wrreq = 0;


            rdreq = 1; @(posedge clock);
            rdreq = 0; @(posedge clock);


            #1;



            check_outputs(0, 0, 32'hFEED_FACE);
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
        input expected_empty;
        input expected_full;
        input [31:0] expected_q;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, full=%b, q=%h",
                         empty, full, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, full=%b, q=%h",
                         expected_empty, expected_full, expected_q);
                $display("  Got:      empty=%b, full=%b, q=%h",
                         empty, full, q);
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
        $dumpvars(0,clock, data, rdreq, wrreq, empty, full, q);
    end

endmodule
