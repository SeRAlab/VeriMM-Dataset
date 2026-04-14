`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] data;
    reg rreq;
    reg sclr;
    reg wreq;
    wire empty;
    wire full;
    wire [31:0] q;
    wire [4:0] usedw;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .rreq(rreq),
        .sclr(sclr),
        .wreq(wreq),
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
        wreq = 0;
        rreq = 0;
        data = 0;
        @(posedge clock);
        #1 sclr = 0;
        @(posedge clock);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();


        data = 32'hDEADBEEF;
        wreq = 1;
        @(posedge clock);
        #1 wreq = 0;
        @(posedge clock);


        rreq = 1;
        @(posedge clock);
        #1 rreq = 0;
        @(posedge clock);


        #1;



        check_outputs(1'b1, 1'b0, 32'hDEADBEEF, 5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();

        for (i = 0; i < 16; i = i + 1) begin
            data = i + 1;
            wreq = 1;
            @(posedge clock);
        end
        #1 wreq = 0;
        @(posedge clock);


        #1;



        check_outputs(1'b0, 1'b1, q, 5'd16);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();


        for (i = 0; i < 16; i = i + 1) begin
            data = i + 100;
            wreq = 1;
            @(posedge clock);
        end
        #1 wreq = 0;


        for (i = 0; i < 16; i = i + 1) begin
            rreq = 1;
            @(posedge clock);
        end
        #1 rreq = 0;
        @(posedge clock);


        #1;



        check_outputs(1'b1, 1'b0, 32'd115, 5'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();


        for (i = 0; i < 8; i = i + 1) begin
            data = i;
            wreq = 1;
            @(posedge clock);
        end
        #1 wreq = 0;


        sclr = 1;
        @(posedge clock);
        #1 sclr = 0;
        @(posedge clock);


        #1;



        check_outputs(1'b1, 1'b0, q, 5'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();


        wreq = 1;
        for (i = 0; i < 20; i = i + 1) begin
            data = i;
            @(posedge clock);
        end
        #1 wreq = 0;
        @(posedge clock);


        #1;



        check_outputs(1'b0, 1'b1, q, 5'd16);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();


        wreq = 1;
        for (i = 0; i < 8; i = i + 1) begin
            data = i;
            @(posedge clock);
        end


        data = 32'd99;
        wreq = 1;
        rreq = 1;
        @(posedge clock);
        #1 wreq = 0;
        rreq = 0;
        @(posedge clock);


        #1;



        check_outputs(1'b0, 1'b0, 32'd0, 5'd8);
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
        $dumpvars(0,clock, data, rreq, sclr, wreq, empty, full, q, usedw);
    end

endmodule
