`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aclr;
    reg clock;
    reg [29:0] data;
    reg rdreq;
    reg wrreq;
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
        .q(q),
        .usedw(usedw)
    );

    // Clock generation (10ns period)
    initial begin
        aclr = 0;
        forever #5 aclr = ~aclr;
    end

        task reset_dut;

        begin
            aclr = 1;
            rdreq = 0;
            wrreq = 0;
            data = 0;
            #12;
            aclr = 0;
            #5;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;


            data = 30'h12345678;
            wrreq = 1;
            @(posedge clock);
            #1 wrreq = 0;


            @(posedge clock);
            rdreq = 1;
            @(posedge clock);
            #1 rdreq = 0;



            @(posedge clock);
            #1;

            check_outputs(30'h12345678, 5'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;


            data = 30'hAAAA_AAAA; wrreq = 1; @(posedge clock);
            data = 30'hBBBB_BBBB; wrreq = 1; @(posedge clock);
            data = 30'hCCCC_CCCC; wrreq = 1; @(posedge clock);
            #1 wrreq = 0;


            rdreq = 1; @(posedge clock);
            rdreq = 1; @(posedge clock);
            #1 rdreq = 0;



            @(posedge clock);
            #1;

            check_outputs(30'hBBBB_BBBB, 5'd1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;


            wrreq = 1;
            for (i = 1; i <= 31; i = i + 1) begin
                data = i;
                @(posedge clock);
            end
            #1 wrreq = 0;


            @(posedge clock);
            #1;

            check_outputs(q, 5'd31);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;


            data = 30'h5555_5555; wrreq = 1; @(posedge clock);
            data = 30'h3333_3333; wrreq = 1; @(posedge clock);
            #1 wrreq = 0;


            #5 aclr = 1;
            #10 aclr = 0;
            #5;


            #1;



            check_outputs(q, 5'd0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;


            data = 30'h1111_1111;
            wrreq = 1;
            @(posedge clock);
            #1;


            data = 30'h2222_2222;
            wrreq = 1;
            rdreq = 1;
            @(posedge clock);
            #1 wrreq = 0; rdreq = 0;



            @(posedge clock);
            #1;

            check_outputs(30'h1111_1111, 5'd1);
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
        input [29:0] expected_q;
        input [4:0] expected_usedw;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q) &&
                expected_usedw === (expected_usedw ^ usedw ^ expected_usedw)) begin
                $display("PASS");
                $display("  Outputs: q=%h, usedw=%h",
                         q, usedw);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h, usedw=%h",
                         expected_q, expected_usedw);
                $display("  Got:      q=%h, usedw=%h",
                         q, usedw);
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
        $dumpvars(0,aclr, clock, data, rdreq, wrreq, q, usedw);
    end

endmodule
