`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [57:0] din;
    reg rd_en;
    reg wr_en;
    wire [57:0] dout;
    wire empty;
    wire full;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .rd_en(rd_en),
        .wr_en(wr_en),
        .dout(dout),
        .empty(empty),
        .full(full)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_en = 0;
            rd_en = 0;
            din = 0;


            while (empty === 1'b0) begin
                rd_en = 1;
                @(posedge clk);
            end
            rd_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial state check", test_num);
            reset_dut();

            #1;


            check_outputs(dout, 1, 0);
        end
        endtask

    task testcase002;

        reg [57:0] test_data;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Write/Read integrity", test_num);
            reset_dut();
            test_data = 58'h3AA_AAAA_BBBB_CCCC;


            din = test_data;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;
            #1;


            rd_en = 1;
            @(posedge clk);
            #1;
            rd_en = 0;


            #1;



            check_outputs(test_data, 1, 0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Fill to capacity (16 items)", test_num);
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                din = i;
                wr_en = 1;
                @(posedge clk);
            end
            wr_en = 0;
            #1;


            #1;



            check_outputs(dout, 0, 1);
        end
        endtask

    task testcase004;

        integer i;
        reg [57:0] last_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Fill and then drain completely", test_num);
            reset_dut();


            for (i = 0; i < 16; i = i + 1) begin
                din = 58'h100 + i;
                wr_en = 1;
                @(posedge clk);
            end
            wr_en = 0;


            rd_en = 1;
            for (i = 0; i < 16; i = i + 1) begin
                last_val = 58'h100 + i;
                @(posedge clk);
                #1;
            end
            rd_en = 0;


            #1;



            check_outputs(last_val, 1, 0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Cyclic wrap-around (half fill, read, refill)", test_num);
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 8; i = i + 1) begin
                din = i;
                @(posedge clk);
            end
            wr_en = 0;


            rd_en = 1;
            for (i = 0; i < 8; i = i + 1) begin
                @(posedge clk);
            end
            rd_en = 0;


            wr_en = 1;
            for (i = 0; i < 16; i = i + 1) begin
                din = 58'hF0 + i;
                @(posedge clk);
            end
            wr_en = 0;
            #1;


            #1;



            check_outputs(dout, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Simultaneous Read and Write", test_num);
            reset_dut();


            din = 58'hA;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            din = 58'hB;
            wr_en = 1;
            rd_en = 1;
            @(posedge clk);
            #1;
            wr_en = 0;
            rd_en = 0;


            #1;



            check_outputs(58'hA, 0, 0);
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
        input [57:0] expected_dout;
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
        $dumpvars(0,clk, din, rd_en, wr_en, dout, empty, full);
    end

endmodule
