`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg din;
    reg rst;
    reg we;
    wire dout;
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
        .rst(rst),
        .we(we),
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
            we = 0;
            din = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Checking Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(dout, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Write then Pop", test_num);
            reset_dut();

            we = 1; din = 1;
            @(posedge clk); #1;

            we = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(1'b1, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: LIFO order check (Push 0, then 1)", test_num);
            reset_dut();

            we = 1; din = 0;
            @(posedge clk); #1;

            we = 1; din = 1;
            @(posedge clk); #1;

            we = 0;
            @(posedge clk); #1;


            #1;



            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %03d: Fill stack to verify Full flag", test_num);
            reset_dut();
            we = 1; din = 1;

            for (i = 0; i < 32; i = i + 1) begin
                @(posedge clk); #1;
            end

            #1;


            check_outputs(dout, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %03d: Overflow - Push to full stack should be ignored", test_num);
            reset_dut();


            we = 1; din = 0;
            for (i = 0; i < 32; i = i + 1) begin
                @(posedge clk); #1;
            end


            we = 1; din = 1;
            @(posedge clk); #1;


            we = 0;
            for (i = 0; i < 32; i = i + 1) begin
                if (empty) break;
                @(posedge clk); #1;
            end


            #1;



            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Pop on empty stack", test_num);
            reset_dut();

            we = 0;
            repeat(5) @(posedge clk); #1;

            #1;


            check_outputs(dout, 1'b1, 1'b0);
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
        input expected_dout;
        input expected_empty;
        input expected_full;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_empty === (expected_empty ^ empty ^ expected_empty) &&
                expected_full === (expected_full ^ full ^ expected_full)) begin
                $display("PASS");
                $display("  Outputs: dout=%b, empty=%b, full=%b",
                         dout, empty, full);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%b, empty=%b, full=%b",
                         expected_dout, expected_empty, expected_full);
                $display("  Got:      dout=%b, empty=%b, full=%b",
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
        $dumpvars(0,clk, din, rst, we, dout, empty, full);
    end

endmodule
