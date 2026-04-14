`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] dataIn;
    reg rd;
    reg resetn;
    reg wr;
    wire [31:0] dataOut;
    wire empty;
    wire full;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dataIn(dataIn),
        .rd(rd),
        .resetn(resetn),
        .wr(wr),
        .dataOut(dataOut),
        .empty(empty),
        .full(full),
        .overflow(overflow)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            wr = 0;
            rd = 0;
            dataIn = 0;
            #20;
            resetn = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Checking initial state", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write then Read", test_num);
            reset_dut();


            @(posedge clk);
            wr = 1;
            dataIn = 32'hAAAA_BBBB;
            @(posedge clk);
            wr = 0;


            @(posedge clk);
            rd = 1;
            @(posedge clk);
            rd = 0;


            #1;



            check_outputs(32'hAAAA_BBBB, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Fill FIFO to full", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                wr = 1;
                dataIn = i + 1;
            end
            @(posedge clk);
            wr = 0;


            #1;



            check_outputs(32'h0, 1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Testing overflow", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                wr = 1;
                dataIn = i;
            end

            @(posedge clk);
            wr = 1;
            dataIn = 32'hFFFF_FFFF;
            @(posedge clk);
            wr = 0;


            #1;



            check_outputs(32'h0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Read back from Full", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                wr = 1;
                dataIn = 32'hD0D0_0000 + i;
            end
            @(posedge clk);
            wr = 0;


            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
                rd = 1;
            end
            @(posedge clk);
            rd = 0;


            #1;



            check_outputs(32'hD0D0_0007, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();


            @(posedge clk);
            wr = 1; dataIn = 32'h1;
            @(posedge clk);
            wr = 1; dataIn = 32'h2;
            @(posedge clk);
            wr = 1; dataIn = 32'h3;
            @(posedge clk);
            wr = 0;


            #5 resetn = 0;
            #15 resetn = 1;


            #1;



            check_outputs(32'h0, 1'b1, 1'b0, 1'b0);
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
        input [31:0] expected_dataOut;
        input expected_empty;
        input expected_full;
        input expected_overflow;
        begin
            if (expected_dataOut === (expected_dataOut ^ dataOut ^ expected_dataOut) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: dataOut=%h, empty=%b, full=%b, overflow=%b",
                         dataOut, empty, full, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataOut=%h, empty=%b, full=%b, overflow=%b",
                         expected_dataOut, expected_empty, expected_full, expected_overflow);
                $display("  Got:      dataOut=%h, empty=%b, full=%b, overflow=%b",
                         dataOut, empty, full, overflow);
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
        $dumpvars(0,clk, dataIn, rd, resetn, wr, dataOut, empty, full, overflow);
    end

endmodule
