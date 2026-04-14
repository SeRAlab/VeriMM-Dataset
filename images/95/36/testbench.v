`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLOCK;
    reg INTERRUPT;
    reg SCLK;
    wire [7:0] DATA_IN;
    wire [7:0] DATA_OUT;
    wire NEW_DATA;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLOCK(CLOCK),
        .INTERRUPT(INTERRUPT),
        .SCLK(SCLK),
        .DATA_IN(DATA_IN),
        .DATA_OUT(DATA_OUT),
        .NEW_DATA(NEW_DATA)
    );

    // Clock generation (10ns period)
    initial begin
        CLOCK = 0;
        forever #5 CLOCK = ~CLOCK;
    end

        task reset_dut;

        begin
            INTERRUPT = 0;
            SCLK = 0;
            repeat(5) @(posedge CLOCK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Initial State Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 8'h00, 1'b0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("\nTestcase %0d: Complete 8-bit Transaction", test_num);
            reset_dut();


            @(posedge CLOCK);
            INTERRUPT = 1;
            @(posedge CLOCK);
            INTERRUPT = 0;
            repeat(2) @(posedge CLOCK);


            for (i = 0; i < 8; i = i + 1) begin
                SCLK = 1;
                repeat(2) @(posedge CLOCK);
                SCLK = 0;
                repeat(2) @(posedge CLOCK);
            end


            repeat(2) @(posedge CLOCK);


            #1;



            check_outputs(DATA_IN, DATA_OUT, 1'b1);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("\nTestcase %0d: Partial 4-bit Transaction", test_num);
            reset_dut();

            INTERRUPT = 1;
            @(posedge CLOCK);
            INTERRUPT = 0;


            for (i = 0; i < 4; i = i + 1) begin
                SCLK = 1;
                repeat(2) @(posedge CLOCK);
                SCLK = 0;
                repeat(2) @(posedge CLOCK);
            end

            repeat(2) @(posedge CLOCK);


            #1;



            check_outputs(DATA_IN, DATA_OUT, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nTestcase %0d: SCLK Pulses without Interrupt", test_num);
            reset_dut();



            for (i = 0; i < 8; i = i + 1) begin
                SCLK = 1;
                repeat(2) @(posedge CLOCK);
                SCLK = 0;
                repeat(2) @(posedge CLOCK);
            end

            repeat(2) @(posedge CLOCK);


            #1;



            check_outputs(DATA_IN, DATA_OUT, 1'b0);
        end
        endtask

    task testcase005;

        integer i, j;
        begin
            test_num = 5;
            $display("\nTestcase %0d: Consecutive Transactions", test_num);
            reset_dut();


            for (j = 0; j < 2; j = j + 1) begin
                INTERRUPT = 1;
                @(posedge CLOCK);
                INTERRUPT = 0;
                repeat(2) @(posedge CLOCK);

                for (i = 0; i < 8; i = i + 1) begin
                    SCLK = 1;
                    repeat(2) @(posedge CLOCK);
                    SCLK = 0;
                    repeat(2) @(posedge CLOCK);
                end
                repeat(2) @(posedge CLOCK);
            end


            #1;



            check_outputs(DATA_IN, DATA_OUT, 1'b1);
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
        input [7:0] expected_DATA_IN;
        input [7:0] expected_DATA_OUT;
        input expected_NEW_DATA;
        begin
            if (expected_DATA_IN === (expected_DATA_IN ^ DATA_IN ^ expected_DATA_IN) &&
                expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT) &&
                expected_NEW_DATA === (expected_NEW_DATA ^ NEW_DATA ^ expected_NEW_DATA)) begin
                $display("PASS");
                $display("  Outputs: DATA_IN=%h, DATA_OUT=%h, NEW_DATA=%b",
                         DATA_IN, DATA_OUT, NEW_DATA);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_IN=%h, DATA_OUT=%h, NEW_DATA=%b",
                         expected_DATA_IN, expected_DATA_OUT, expected_NEW_DATA);
                $display("  Got:      DATA_IN=%h, DATA_OUT=%h, NEW_DATA=%b",
                         DATA_IN, DATA_OUT, NEW_DATA);
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
        $dumpvars(0,CLOCK, INTERRUPT, SCLK, DATA_IN, DATA_OUT, NEW_DATA);
    end

endmodule
