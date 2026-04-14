`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg wr;
    wire [7:0] dout;
    wire rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .wr(wr),
        .dout(dout),
        .rd(rd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr = 0;
            din = 0;
            repeat(10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial Empty State Check", test_num);
            reset_dut();


            #1;



            check_outputs(dout, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Write/Read Operation", test_num);
            reset_dut();
            @(posedge clk);
            wr <= 1;
            din <= 8'hA5;
            @(posedge clk);
            wr <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Sequential Data Flow", test_num);
            reset_dut();
            @(posedge clk);
            wr <= 1; din <= 8'h11; @(posedge clk);
            wr <= 1; din <= 8'h22; @(posedge clk);
            wr <= 1; din <= 8'h33; @(posedge clk);
            wr <= 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h33, 1'b1);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill to Depth 8", test_num);
            reset_dut();
            @(posedge clk);
            for (i = 1; i <= 8; i = i + 1) begin
                wr <= 1;
                din <= i[7:0];
                @(posedge clk);
            end
            wr <= 0;


            #1;
            #1;

            check_outputs(8'h08, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Drain and Persistence Check", test_num);
            reset_dut();
            @(posedge clk);
            wr <= 1; din <= 8'hFF; @(posedge clk);
            wr <= 0;
            @(posedge clk);
            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(8'hFF, 1'b0);
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
        input [7:0] expected_dout;
        input expected_rd;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_rd === (expected_rd ^ rd ^ expected_rd)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, rd=%b",
                         dout, rd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, rd=%b",
                         expected_dout, expected_rd);
                $display("  Got:      dout=%h, rd=%b",
                         dout, rd);
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
        $dumpvars(0,clk, din, wr, dout, rd);
    end

endmodule
