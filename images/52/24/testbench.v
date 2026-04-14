`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [127:0] din;
    reg rd_en;
    reg srst;
    reg wr_en;
    wire [127:0] dout;
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
        .srst(srst),
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
            srst = 1;
            wr_en = 0;
            rd_en = 0;
            din = 0;
            @(posedge clk);
            #1 srst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(128'hx, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Write/Read", test_num);
            reset_dut();


            wr_en = 1;
            din = 128'h0123456789ABCDEF0123456789ABCDEF;
            @(posedge clk);
            #1 wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(128'h0123456789ABCDEF0123456789ABCDEF, 1'b1, 1'b0);
            rd_en = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Fill to Full", test_num);
            reset_dut();

            wr_en = 1;
            for (i = 0; i < 1024; i = i + 1) begin
                din = i;
                @(posedge clk);
            end
            #1 wr_en = 0;


            #1;



            check_outputs(dout, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Data Integrity Check", test_num);
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 1024; i = i + 1) begin
                din = i;
                @(posedge clk);
            end
            #1 wr_en = 0;


            rd_en = 1;
            for (i = 0; i < 1023; i = i + 1) begin
                @(posedge clk);
            end

            #1;

            #1;


            check_outputs(1023, 1'b0, 1'b0);
            @(posedge clk);
            rd_en = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Pointer Wraparound", test_num);
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 512; i = i + 1) begin
                din = i;
                @(posedge clk);
            end
            wr_en = 0;


            rd_en = 1;
            repeat(512) @(posedge clk);
            rd_en = 0;


            wr_en = 1;
            for (i = 0; i < 1024; i = i + 1) begin
                din = i + 5000;
                @(posedge clk);
            end
            #1 wr_en = 0;


            #1;



            check_outputs(dout, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Overflow Protection", test_num);
            reset_dut();


            wr_en = 1;
            for (i = 0; i < 1024; i = i + 1) begin
                din = i;
                @(posedge clk);
            end


            for (i = 0; i < 10; i = i + 1) begin
                din = 128'hFFFF;
                @(posedge clk);
            end
            #1 wr_en = 0;


            #1;



            check_outputs(dout, 1'b0, 1'b1);
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
        input [127:0] expected_dout;
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
        $dumpvars(0,clk, din, rd_en, srst, wr_en, dout, empty, full);
    end

endmodule
