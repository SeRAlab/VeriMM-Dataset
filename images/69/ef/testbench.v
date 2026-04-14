`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [7:0] din;
    reg ren;
    reg wen;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .ren(ren),
        .wen(wen),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            din = 0;
            wen = 0;
            ren = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            addr = 8'h01;
            din  = 8'hA5;
            wen  = 1;
            ren  = 0;
            @(posedge clk);
            #1;


            wen  = 0;
            ren  = 1;
            @(posedge clk);

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            addr = 8'h01;
            din  = 8'h55;
            wen  = 1;
            ren  = 0;
            @(posedge clk);
            #1;

            wen  = 0;
            ren  = 0;
            @(posedge clk);

            #1;


            check_outputs(8'hzz);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            addr = 8'hFF;
            ren  = 1;
            wen  = 0;
            @(posedge clk);


            #1;



            check_outputs(8'hzz);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            addr = 8'hFE;
            din  = 8'h12;
            wen  = 1;
            @(posedge clk);
            #1;


            wen  = 0;
            ren  = 1;
            @(posedge clk);

            #1;


            check_outputs(8'hzz);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            addr = 8'h02;
            din  = 8'hAA;
            wen  = 1;
            @(posedge clk);
            #1;


            addr = 8'h03;
            din  = 8'hBB;
            wen  = 1;
            @(posedge clk);
            #1;


            addr = 8'h02;
            wen  = 0;
            ren  = 1;
            @(posedge clk);

            #1;


            check_outputs(8'hAA);
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
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,addr, clk, din, ren, wen, dout);
    end

endmodule
