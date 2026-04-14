`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] readaddr1;
    reg we;
    reg [31:0] writeaddr1;
    reg [31:0] writein1;
    wire [31:0] readout1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .readaddr1(readaddr1),
        .we(we),
        .writeaddr1(writeaddr1),
        .writein1(writein1),
        .readout1(readout1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            readaddr1 = 0;
            writeaddr1 = 0;
            writein1 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Read back", test_num);


            we = 1;
            writeaddr1 = 32'h10;
            writein1 = 32'hDEADBEEF;
            @(posedge clk);
            #1;


            we = 0;
            readaddr1 = 32'h10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Overwrite check", test_num);


            we = 1;
            writeaddr1 = 32'hA5;
            writein1 = 32'h11112222;
            @(posedge clk);
            #1;


            writein1 = 32'h33334444;
            @(posedge clk);
            #1;


            we = 0;
            readaddr1 = 32'hA5;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h33334444);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Memory independence check", test_num);


            we = 1;
            writeaddr1 = 32'h01;
            writein1 = 32'hAAAA5555;
            @(posedge clk);
            #1;


            writeaddr1 = 32'h02;
            writein1 = 32'h5555AAAA;
            @(posedge clk);
            #1;


            we = 0;
            readaddr1 = 32'h01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Write Enable (WE) check", test_num);


            we = 1;
            writeaddr1 = 32'h50;
            writein1 = 32'hFACECAFE;
            @(posedge clk);
            #1;


            we = 0;
            writeaddr1 = 32'h50;
            writein1 = 32'h0;
            @(posedge clk);
            #1;


            readaddr1 = 32'h50;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFACECAFE);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Simultaneous Read and Write", test_num);


            we = 1;
            writeaddr1 = 32'h100;
            writein1 = 32'h99887766;
            @(posedge clk);
            #1;


            we = 1;
            writeaddr1 = 32'h200;
            writein1 = 32'h11223344;
            readaddr1 = 32'h100;
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'h99887766);
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
        input [31:0] expected_readout1;
        begin
            if (expected_readout1 === (expected_readout1 ^ readout1 ^ expected_readout1)) begin
                $display("PASS");
                $display("  Outputs: readout1=%h",
                         readout1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readout1=%h",
                         expected_readout1);
                $display("  Got:      readout1=%h",
                         readout1);
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
        $dumpvars(0,clk, readaddr1, we, writeaddr1, writein1, readout1);
    end

endmodule
