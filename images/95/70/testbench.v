`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [10:0] rdaddr;
    reg wr_stb;
    reg [10:0] wraddr;
    reg [7:0] wrdata;
    wire [7:0] rddata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rdaddr(rdaddr),
        .wr_stb(wr_stb),
        .wraddr(wraddr),
        .wrdata(wrdata),
        .rddata(rddata)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_stb = 0;
            wraddr = 0;
            wrdata = 0;
            rdaddr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();


            wraddr = 11'h010;
            wrdata = 8'hA5;
            wr_stb = 1;
            @(posedge clk);
            #1;
            wr_stb = 0;


            rdaddr = 11'h010;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Basic Write/Read", test_num);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();


            wraddr = 11'h020;
            wrdata = 8'hFF;
            wr_stb = 0;
            @(posedge clk);
            #1;


            rdaddr = 11'h020;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Write Strobe Logic", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();


            wraddr = 11'h055;
            wrdata = 8'h11;
            wr_stb = 1;
            @(posedge clk);
            #1;


            wrdata = 8'h22;
            @(posedge clk);
            #1;
            wr_stb = 0;


            rdaddr = 11'h055;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Overwrite Memory", test_num);
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            wraddr = 11'h7FF;
            wrdata = 8'hDE;
            wr_stb = 1;
            @(posedge clk);
            #1;
            wr_stb = 0;

            rdaddr = 11'h7FF;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Max Address Test", test_num);
            #1;

            check_outputs(8'hDE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();


            wraddr = 11'h100;
            wrdata = 8'hAA;
            wr_stb = 1;
            @(posedge clk);
            #1;


            wraddr = 11'h200;
            wrdata = 8'hBB;
            rdaddr = 11'h100;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Multi-access Logic", test_num);
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
        input [7:0] expected_rddata;
        begin
            if (expected_rddata === (expected_rddata ^ rddata ^ expected_rddata)) begin
                $display("PASS");
                $display("  Outputs: rddata=%h",
                         rddata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rddata=%h",
                         expected_rddata);
                $display("  Got:      rddata=%h",
                         rddata);
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
        $dumpvars(0,clk, rdaddr, wr_stb, wraddr, wrdata, rddata);
    end

endmodule
