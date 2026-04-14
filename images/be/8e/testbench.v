`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg clk;
    reg [7:0] din;
    reg [9:0] read_addr;
    reg we;
    wire [7:0] dout;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .read_addr(read_addr),
        .we(we),
        .dout(dout),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            addr = 0;
            din = 0;
            read_addr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            addr = 10'h010;
            din = 8'hAB;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;

            read_addr = 10'h000;
            #1;

            check_outputs(8'hAB, 8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            addr = 10'h100;
            din = 8'h55;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;

            read_addr = 10'h100;
            #2;

            #1;


            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            addr = 10'h020;
            din = 8'hEE;
            we = 1;
            @(posedge clk);
            #1;

            din = 8'hFF;
            we = 0;
            @(posedge clk);
            #1;

            read_addr = 10'h020;

            #1;


            check_outputs(8'hEE, 8'hEE);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            addr = 10'h005;
            din = 8'h11;
            we = 1;
            @(posedge clk);
            #1;

            addr = 10'h006;
            din = 8'h22;
            read_addr = 10'h005;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h22, 8'h11);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            addr = 10'h3FF;
            din = 8'h77;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;
            read_addr = 10'h3FF;
            #1;

            check_outputs(8'h77, 8'h77);
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
        input [7:0] expected_q;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, q=%h",
                         dout, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, q=%h",
                         expected_dout, expected_q);
                $display("  Got:      dout=%h, q=%h",
                         dout, q);
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
        $dumpvars(0,addr, clk, din, read_addr, we, dout, q);
    end

endmodule
