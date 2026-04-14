`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] datorom;
    reg [7:0] direccionram;
    reg wram;
    wire [15:0] datoram;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .datorom(datorom),
        .direccionram(direccionram),
        .wram(wram),
        .datoram(datoram)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            datorom = 16'h0000;
            direccionram = 8'h00;
            wram = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            wram = 0;
            direccionram = 8'h01;
            datorom = 16'hAAAA;
            @(posedge clk);
            #1;

            wram = 1;
            direccionram = 8'h01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            wram = 0;
            direccionram = 8'hFF;
            datorom = 16'h5555;
            @(posedge clk);
            #1;

            wram = 1;
            direccionram = 8'hFF;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            wram = 0;
            direccionram = 8'h20;
            datorom = 16'h1111;
            @(posedge clk);
            #1;

            wram = 0;
            direccionram = 8'h20;
            datorom = 16'h2222;
            @(posedge clk);
            #1;

            wram = 1;
            direccionram = 8'h20;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h2222);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            wram = 0;
            direccionram = 8'h10;
            datorom = 16'h1010;
            @(posedge clk);
            #1;

            wram = 0;
            direccionram = 8'h11;
            datorom = 16'h1111;
            @(posedge clk);
            #1;

            wram = 1;
            direccionram = 8'h10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1010);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            wram = 0;
            direccionram = 8'h80;
            datorom = 16'hFFFF;
            @(posedge clk);
            #1;

            wram = 0;
            direccionram = 8'h81;
            datorom = 16'h0000;
            @(posedge clk);
            #1;

            wram = 1;
            direccionram = 8'h80;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            wram = 0;
            direccionram = 8'h50;
            datorom = 16'h1234;
            @(posedge clk);
            #1;

            wram = 1;
            direccionram = 8'h50;
            datorom = 16'h9999;
            @(posedge clk);
            #1;

            wram = 1;
            direccionram = 8'h50;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h1234);
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
        input [15:0] expected_datoram;
        begin
            if (expected_datoram === (expected_datoram ^ datoram ^ expected_datoram)) begin
                $display("PASS");
                $display("  Outputs: datoram=%h",
                         datoram);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: datoram=%h",
                         expected_datoram);
                $display("  Got:      datoram=%h",
                         datoram);
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
        $dumpvars(0,clk, datorom, direccionram, wram, datoram);
    end

endmodule
