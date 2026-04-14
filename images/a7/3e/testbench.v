`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg ren;
    reg rst;
    reg wen;
    wire [7:0] dout;
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
        .ren(ren),
        .rst(rst),
        .wen(wen),
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
            rst = 1;
            wen = 0;
            ren = 0;
            din = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Checking Initial Reset State", test_num);

            #1;


            check_outputs(dout, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Single Write and Read", test_num);


            din = 8'h55; wen = 1;
            @(posedge clk);
            wen = 0;


            ren = 1;
            @(posedge clk);
            #1;
            ren = 0;

            #1;


            check_outputs(8'h55, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Filling FIFO to Full (16 elements)", test_num);

            for (i = 0; i < 16; i = i + 1) begin
                din = i; wen = 1;
                @(posedge clk);
            end
            wen = 0;
            #1;


            #1;



            check_outputs(dout, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Fill and Empty Entire FIFO", test_num);


            for (i = 1; i <= 16; i = i + 1) begin
                din = i; wen = 1;
                @(posedge clk);
            end
            wen = 0;


            for (i = 1; i <= 16; i = i + 1) begin
                ren = 1;
                @(posedge clk);
            end
            #1;
            ren = 0;


            #1;



            check_outputs(8'd16, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Overflow Test (Writing 17 times to depth 16)", test_num);

            for (i = 0; i < 17; i = i + 1) begin
                din = i; wen = 1;
                @(posedge clk);
            end
            wen = 0;
            #1;


            #1;



            check_outputs(dout, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Underflow Test (Reading empty FIFO)", test_num);

            ren = 1;
            @(posedge clk);
            ren = 0;
            #1;


            #1;



            check_outputs(dout, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Simultaneous Read and Write", test_num);


            din = 8'hAA; wen = 1;
            @(posedge clk);


            din = 8'hBB; wen = 1; ren = 1;
            @(posedge clk);
            #1;
            wen = 0; ren = 0;


            #1;



            check_outputs(8'hAA, 1'b0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Data Integrity (FIFO Order)", test_num);


            din = 8'h0A; wen = 1; @(posedge clk);
            din = 8'h0B; wen = 1; @(posedge clk);
            wen = 0;


            ren = 1; @(posedge clk);
            #1;

            if (dout !== 8'h0A) $display("Error: Expected 0x0A, got %h", dout);


            ren = 1; @(posedge clk);
            #1;
            ren = 0;


            #1;



            check_outputs(8'h0B, 1'b1, 1'b0);
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
        testcase008();
        
        
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
        $dumpvars(0,clk, din, ren, rst, wen, dout, empty, full);
    end

endmodule
