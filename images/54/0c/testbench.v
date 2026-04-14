`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [18:0] DIN;
    reg IN_EN;
    reg OUT_EN;
    reg RST;
    wire [18:0] DOUT;
    wire EMPTY;
    wire FULL;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DIN(DIN),
        .IN_EN(IN_EN),
        .OUT_EN(OUT_EN),
        .RST(RST),
        .DOUT(DOUT),
        .EMPTY(EMPTY),
        .FULL(FULL)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            IN_EN = 0;
            OUT_EN = 0;
            DIN = 0;
            @(posedge CLK);
            #1 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Checking initial state after reset", test_num);
            reset_dut();
            @(posedge CLK);
            #1;

            #1;


            check_outputs(DOUT, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single write and read operation", test_num);
            reset_dut();


            @(posedge CLK);
            DIN = 19'h5A5A5;
            IN_EN = 1;
            @(posedge CLK);
            IN_EN = 0;


            @(posedge CLK);
            OUT_EN = 1;
            @(posedge CLK);
            OUT_EN = 0;

            #1;

            #1;


            check_outputs(19'h5A5A5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: FIFO Order check (Burst)", test_num);
            reset_dut();


            @(posedge CLK);
            DIN = 19'h00001; IN_EN = 1; @(posedge CLK);
            DIN = 19'h00002; IN_EN = 1; @(posedge CLK);
            DIN = 19'h00003; IN_EN = 1; @(posedge CLK);
            IN_EN = 0;


            @(posedge CLK);
            OUT_EN = 1;
            @(posedge CLK);
            @(posedge CLK);
            @(posedge CLK);
            OUT_EN = 0;

            #1;

            #1;


            check_outputs(19'h00003, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Fill FIFO until FULL flag is high", test_num);
            reset_dut();


            for (i = 0; i < 1024; i = i + 1) begin
                if (!FULL) begin
                    DIN = i;
                    IN_EN = 1;
                    @(posedge CLK);
                end
            end
            IN_EN = 0;
            #1;

            #1;


            check_outputs(DOUT, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous read and write", test_num);
            reset_dut();


            @(posedge CLK);
            DIN = 19'h11111;
            IN_EN = 1;
            @(posedge CLK);


            DIN = 19'h22222;
            IN_EN = 1;
            OUT_EN = 1;
            @(posedge CLK);


            IN_EN = 0;
            @(posedge CLK);
            OUT_EN = 0;

            #1;

            #1;


            check_outputs(19'h22222, 1'b1, 1'b0);
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
        input [18:0] expected_DOUT;
        input expected_EMPTY;
        input expected_FULL;
        begin
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT) &&
                expected_EMPTY === (expected_EMPTY ^ EMPTY ^ expected_EMPTY) &&
                expected_FULL === (expected_FULL ^ FULL ^ expected_FULL)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h, EMPTY=%b, FULL=%b",
                         DOUT, EMPTY, FULL);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h, EMPTY=%b, FULL=%b",
                         expected_DOUT, expected_EMPTY, expected_FULL);
                $display("  Got:      DOUT=%h, EMPTY=%b, FULL=%b",
                         DOUT, EMPTY, FULL);
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
        $dumpvars(0,CLK, DIN, IN_EN, OUT_EN, RST, DOUT, EMPTY, FULL);
    end

endmodule
