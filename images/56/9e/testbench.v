`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [15:0] data;
    reg rdreq;
    reg wrreq;
    wire empty;
    wire full;
    wire [15:0] q;
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
            rdreq <= 0;
            wrreq <= 0;
            data <= 16'h0000;


            repeat(5) @(posedge clock);


            while (empty === 1'b0) begin
                rdreq <= 1;
                @(posedge clock);
            end
            rdreq <= 0;
            repeat(2) @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            data <= 16'hA5A5;
            wrreq <= 1;
            @(posedge clock);
            wrreq <= 0;


            @(posedge clock);
            rdreq <= 1;
            @(posedge clock);
            rdreq <= 0;
            @(posedge clock);


            #1;



            check_outputs(1'b1, 1'b0, 16'hA5A5, 8'h00);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Writes - usedw check", test_num);
            reset_dut();


            for (i = 1; i <= 10; i = i + 1) begin
                data <= i;
                wrreq <= 1;
                @(posedge clock);
            end
            wrreq <= 0;
            @(posedge clock);


            #1;



            check_outputs(1'b0, 1'b0, q, 8'd10);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill FIFO to maximum capacity", test_num);
            reset_dut();


            for (i = 0; i < 256; i = i + 1) begin
                data <= i;
                wrreq <= 1;
                @(posedge clock);
            end
            wrreq <= 0;
            @(posedge clock);


            #1;



            check_outputs(1'b0, 1'b1, q, 8'h00);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill and then Empty the FIFO", test_num);
            reset_dut();


            for (i = 0; i < 256; i = i + 1) begin
                data <= 16'hFEED;
                wrreq <= 1;
                @(posedge clock);
            end
            wrreq <= 0;


            rdreq <= 1;
            repeat(256) @(posedge clock);
            rdreq <= 0;
            @(posedge clock);


            #1;



            check_outputs(1'b1, 1'b0, 16'hFEED, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify FIFO Data Order (FIFO behavior)", test_num);
            reset_dut();


            data <= 16'h1111; wrreq <= 1; @(posedge clock);
            data <= 16'h2222; wrreq <= 1; @(posedge clock);
            data <= 16'h3333; wrreq <= 1; @(posedge clock);
            wrreq <= 0;


            rdreq <= 1; @(posedge clock);
            @(posedge clock);
            rdreq <= 0;
            @(posedge clock);


            #1;



            check_outputs(1'b0, 1'b0, 16'h2222, 8'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow and Underflow Robustness", test_num);
            reset_dut();


            rdreq <= 1;
            repeat(5) @(posedge clock);
            rdreq <= 0;


            if (empty !== 1'b1) begin
                $display("FAIL: FIFO not empty after underflow attempts");
            end


            data <= 16'hAAAA; wrreq <= 1; @(posedge clock);
            data <= 16'hBBBB; wrreq <= 1; @(posedge clock);
            wrreq <= 0; @(posedge clock);


            rdreq <= 1;
            repeat(3) @(posedge clock);
            rdreq <= 0;
            @(posedge clock);


            #1;



            check_outputs(1'b1, 1'b0, 16'hBBBB, 8'h00);
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
        input [15:0] expected_q;
        input [7:0] expected_usedw;
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
        $dumpvars(0,clock, data, rdreq, wrreq, empty, full, q, usedw);
    end

endmodule
