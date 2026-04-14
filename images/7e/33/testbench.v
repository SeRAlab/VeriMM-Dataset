`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aclr;
    reg clock;
    reg [32:0] data;
    reg rdreq;
    reg wrreq;
    wire empty;
    wire [32:0] q;
    wire [8:0] usedw;

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
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(1'b1, 33'h0, 9'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clock);
            wrreq = 1;
            data = 33'h1AAAA_BBBB;
            @(posedge clock);
            wrreq = 0;




            @(posedge clock);
            rdreq = 1;
            @(posedge clock);
            rdreq = 0;

            #1;


            check_outputs(1'b1, 33'h1AAAA_BBBB, 9'h0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clock);
            wrreq = 1;
            for(i=0; i<10; i=i+1) begin
                data = i;
                @(posedge clock);
            end
            wrreq = 0;

            #1;


            check_outputs(1'b0, 33'h0, 9'd10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            @(posedge clock);
            wrreq = 1;
            for(i=0; i<511; i=i+1) begin
                data = i;
                @(posedge clock);
            end
            wrreq = 0;

            #1;


            check_outputs(1'b0, 33'h0, 9'd511);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            @(posedge clock);
            wrreq = 1;
            data = 33'hC0DE_C0DE;
            @(posedge clock);
            wrreq = 0;


            @(posedge clock);
            wrreq = 1;
            rdreq = 1;
            data = 33'hDA7A_DA7A;
            @(posedge clock);
            wrreq = 0;
            rdreq = 0;



            #1;




            check_outputs(1'b0, 33'hDA7A_DA7A, 9'h1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            @(posedge clock);
            wrreq = 1;
            data = 33'hFFFF_FFFF;
            @(posedge clock);
            data = 33'hEEEE_EEEE;
            @(posedge clock);
            wrreq = 0;


            aclr = 1;
            #5;
            aclr = 0;
            #5;


            #1;



            check_outputs(1'b1, 33'h0, 9'h0);
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
        input [32:0] expected_q;
        input [8:0] expected_usedw;
        begin
            if (expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_usedw === (expected_usedw ^ usedw ^ expected_usedw)) begin
                $display("PASS");
                $display("  Outputs: empty=%b, q=%h, usedw=%h",
                         empty, q, usedw);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: empty=%b, q=%h, usedw=%h",
                         expected_empty, expected_q, expected_usedw);
                $display("  Got:      empty=%b, q=%h, usedw=%h",
                         empty, q, usedw);
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
        $dumpvars(0,aclr, clock, data, rdreq, wrreq, empty, q, usedw);
    end

endmodule
