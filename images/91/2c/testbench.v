`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [7:0] din;
    reg rd;
    reg reset;
    reg wr;
    wire [7:0] dout;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .din(din),
        .rd(rd),
        .reset(reset),
        .wr(wr),
        .dout(dout),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            rd = 0;
            wr = 0;
            din = 0;
            #15;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(8'hxx, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clock);
            #1; wr = 1; din = 8'hA5;
            @(posedge clock);
            #1; wr = 0;


            @(posedge clock);
            #1; rd = 1;
            @(posedge clock);
            #1; rd = 0;


            #1;



            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clock);
                #1; wr = 1; din = i[7:0];
            end
            @(posedge clock);
            #1; wr = 0;


            #1;



            check_outputs(8'h00, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clock);
                #1; wr = 1; din = i[7:0] + 8'h10;
            end
            @(posedge clock);
            #1; wr = 0;


            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clock);
                #1; rd = 1;
                @(posedge clock);
                #1; rd = 0;
            end


            #1;



            check_outputs(8'h1F, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            for (i = 0; i < 18; i = i + 1) begin
                @(posedge clock);
                #1; wr = 1; din = i[7:0];
            end
            @(posedge clock);
            #1; wr = 0;


            for (i = 0; i < 20; i = i + 1) begin
                @(posedge clock);
                #1; rd = 1;
                @(posedge clock);
                #1; rd = 0;
            end


            #1;



            check_outputs(8'h0F, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clock);
                #1; wr = 1; din = i[7:0];
            end
            @(posedge clock);
            #1; wr = 0;


            for (i = 0; i < 5; i = i + 1) begin
                @(posedge clock);
                #1; rd = 1;
                @(posedge clock);
                #1; rd = 0;
            end


            for (i = 0; i < 10; i = i + 1) begin
                @(posedge clock);
                #1; wr = 1; din = i[7:0] + 8'hF0;
            end
            @(posedge clock);
            #1; wr = 0;


            for (i = 0; i < 15; i = i + 1) begin
                @(posedge clock);
                #1; rd = 1;
                @(posedge clock);
                #1; rd = 0;
            end

            #1;


            check_outputs(8'hF9, 1'b1, 1'b0);
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
        input [7:0] expected_dout;
        input expected_empty;
        input expected_full;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, empty=%b, full=%b",
                         dout, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, empty=%b, full=%b",
                         expected_dout, expected_empty, expected_full);
                $display("  Got:      dout=%h, empty=%b, full=%b",
                         dout, empty, full);
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
        $dumpvars(0,clock, din, rd, reset, wr, dout, empty, full);
    end

endmodule
