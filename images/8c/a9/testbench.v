`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg aclr;
    reg clock;
    reg [30:0] data;
    reg rdreq;
    reg wrreq;
    wire almost_full;
    wire empty;
    wire full;
    wire [30:0] q;
    wire [6:0] usedw;

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
            data = 0;
            @(posedge clock);
            #2;
            aclr = 0;
            @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0, 1, 0, 31'bx, 7'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            wrreq = 1;
            data = 31'h5A5A5A5A;
            @(posedge clock);
            #2 wrreq = 0;


            @(posedge clock);
            #2 rdreq = 1;
            @(posedge clock);
            #2 rdreq = 0;


            #1;



            check_outputs(0, 1, 0, 31'h5A5A5A5A, 7'd0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();


            for (i = 0; i < 128; i = i + 1) begin
                wrreq = 1;
                data = i;
                @(posedge clock);
                #2;
            end
            wrreq = 0;




            #1;





            check_outputs(1, 0, 1, 31'bx, usedw);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();


            wrreq = 1;
            for (i = 0; i < 128; i = i + 1) begin
                data = i;
                @(posedge clock);
                #2;
            end

            data = 31'h7FFFFFFF;
            @(posedge clock);
            #2 wrreq = 0;


            rdreq = 1;
            @(posedge clock);
            #2 rdreq = 0;

            #1;


            check_outputs(almost_full, 0, 0, 31'd0, usedw);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            rdreq = 1;
            @(posedge clock);
            #2 rdreq = 0;


            #1;



            check_outputs(0, 1, 0, q, 7'd0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            reset_dut();


            wrreq = 1;
            for (i = 0; i < 5; i = i + 1) begin
                data = i + 10;
                @(posedge clock);
                #2;
            end


            rdreq = 1;
            for (i = 0; i < 10; i = i + 1) begin
                data = i + 100;
                @(posedge clock);
                #2;
            end
            wrreq = 0;
            rdreq = 0;


            #1;



            check_outputs(0, 0, 0, q, 7'd5);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();


            wrreq = 1;
            data = 31'h11111111;
            @(posedge clock);
            @(posedge clock);
            #2 wrreq = 0;


            #3 aclr = 1;
            #10 aclr = 0;
            @(posedge clock);


            #1;



            check_outputs(0, 1, 0, 31'bx, 7'd0);
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
        input [30:0] expected_q;
        input [6:0] expected_usedw;
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
