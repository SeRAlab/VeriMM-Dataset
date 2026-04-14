`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg [7:0] letter_in;
    reg rst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .letter_in(letter_in),
        .rst(rst)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            letter_in = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 1;
            @(posedge clk);
            letter_in = 8'h41; @(posedge clk);
            letter_in = 8'h42; @(posedge clk);
            letter_in = 8'h00; @(posedge clk);
            data_in = 0;
            @(posedge clk);

            #1;


            check_outputs(32'h00004142, dut.mem[0]);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 1;
            @(posedge clk);

            letter_in = 8'h43; @(posedge clk);
            letter_in = 8'h41; @(posedge clk);
            letter_in = 8'h54; @(posedge clk);
            letter_in = 8'h00; @(posedge clk);

            letter_in = 8'h44; @(posedge clk);
            letter_in = 8'h4F; @(posedge clk);
            letter_in = 8'h47; @(posedge clk);
            letter_in = 8'h00; @(posedge clk);
            data_in = 0;
            @(posedge clk);
            #1;

            check_outputs(32'h00434154, dut.mem[0]);
            #1;

            check_outputs(32'h00444F47, dut.mem[1]);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 1;
            @(posedge clk);
            letter_in = 8'hFF; @(posedge clk);
            rst = 1; #1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);

            #1;


            check_outputs(32'h0, dut.mem[0]);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            data_in = 1;
            @(posedge clk);
            letter_in = 8'h00; @(posedge clk);
            data_in = 0;
            @(posedge clk);
            #1;

            check_outputs(32'h0, dut.mem[0]);
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,clk, data_in, letter_in, rst);
    end

endmodule
