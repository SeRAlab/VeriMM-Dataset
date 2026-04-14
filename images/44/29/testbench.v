`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR;
    reg DEQ;
    reg [127:0] D_IN;
    reg ENQ;
    reg RST_N;
    wire [127:0] D_OUT;
    wire EMPTY_N;
    wire FULL_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CLR(CLR),
        .DEQ(DEQ),
        .D_IN(D_IN),
        .ENQ(ENQ),
        .RST_N(RST_N),
        .D_OUT(D_OUT),
        .EMPTY_N(EMPTY_N),
        .FULL_N(FULL_N)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST_N = 0;
            CLR = 0;
            ENQ = 0;
            DEQ = 0;
            D_IN = 0;
            #20;
            RST_N = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Enqueue/Dequeue");
            reset_dut();
            @(posedge CLK);
            ENQ = 1;
            D_IN = 128'hABCDE;
            @(posedge CLK);
            ENQ = 0;
            #1;

            #1;


            check_outputs(128'hABCDE, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: FIFO Ordering");
            reset_dut();
            @(posedge CLK);
            ENQ = 1; D_IN = 128'h1; @(posedge CLK);
            ENQ = 1; D_IN = 128'h2; @(posedge CLK);
            ENQ = 0;
            @(posedge CLK);
            DEQ = 1; @(posedge CLK);
            DEQ = 0;
            #1;

            #1;


            check_outputs(128'h2, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Synchronous Clear");
            reset_dut();
            @(posedge CLK);
            ENQ = 1; D_IN = 128'hFFFF; @(posedge CLK);
            ENQ = 0;
            @(posedge CLK);
            CLR = 1; @(posedge CLK);
            CLR = 0;
            #1;



            #1;




            check_outputs(D_OUT, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            $display("Running testcase004: Fill FIFO");
            reset_dut();
            @(posedge CLK);
            ENQ = 1;

            for(i=0; i<16; i=i+1) begin
                D_IN = i;
                @(posedge CLK);
                if (FULL_N == 0) i = 16;
            end
            ENQ = 0;
            #1;

            #1;


            check_outputs(D_OUT, 1'b1, FULL_N);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Underflow");
            reset_dut();
            @(posedge CLK);
            DEQ = 1; @(posedge CLK);
            DEQ = 0;
            #1;

            #1;


            check_outputs(D_OUT, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Simultaneous ENQ/DEQ");
            reset_dut();

            @(posedge CLK);
            ENQ = 1; D_IN = 128'hAAAA; @(posedge CLK);

            ENQ = 1; D_IN = 128'hBBBB;
            DEQ = 1; @(posedge CLK);
            ENQ = 0; DEQ = 0;
            #1;

            #1;


            check_outputs(128'hBBBB, 1'b1, 1'b1);
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
        input [127:0] expected_D_OUT;
        input expected_EMPTY_N;
        input expected_FULL_N;
        begin
            if (expected_D_OUT === (expected_D_OUT ^ D_OUT ^ expected_D_OUT) &&
                expected_EMPTY_N === (expected_EMPTY_N ^ EMPTY_N ^ expected_EMPTY_N) &&
                expected_FULL_N === (expected_FULL_N ^ FULL_N ^ expected_FULL_N)) begin
                $display("PASS");
                $display("  Outputs: D_OUT=%h, EMPTY_N=%b, FULL_N=%b",
                         D_OUT, EMPTY_N, FULL_N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: D_OUT=%h, EMPTY_N=%b, FULL_N=%b",
                         expected_D_OUT, expected_EMPTY_N, expected_FULL_N);
                $display("  Got:      D_OUT=%h, EMPTY_N=%b, FULL_N=%b",
                         D_OUT, EMPTY_N, FULL_N);
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
        $dumpvars(0,CLK, CLR, DEQ, D_IN, ENQ, RST_N, D_OUT, EMPTY_N, FULL_N);
    end

endmodule
