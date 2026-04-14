`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg rae;
    reg [7:0] wd;
    reg we;
    wire [7:0] rd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .rae(rae),
        .wd(wd),
        .we(we),
        .rd(rd)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            addr = 0;
            rae = 0;
            wd = 0;
            we = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            addr = 8'h05;
            wd = 8'hAA;
            we = 1;
            @(posedge clk);
            we = 0;


            @(posedge clk);
            addr = 8'h05;
            rae = 1;
            @(posedge clk);
            rae = 0;


            #1;
            $display("Testcase %0d: Basic Write/Read", test_num);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            addr = 8'h10; wd = 8'h11; we = 1;
            @(posedge clk);


            addr = 8'h20; wd = 8'h22; we = 1;
            @(posedge clk);
            we = 0;


            addr = 8'h10; rae = 1;
            @(posedge clk);
            rae = 0;



            addr = 8'h20; rae = 1;
            @(posedge clk);
            rae = 0;

            #1;
            $display("Testcase %0d: Multiple Locations (Address 0x20)", test_num);
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            addr = 8'h80; wd = 8'h55; we = 1;
            @(posedge clk);
            we = 0;


            addr = 8'h80; rae = 1;
            @(posedge clk);
            rae = 0;


            @(posedge clk);
            addr = 8'hFF;

            #1;
            $display("Testcase %0d: RAE Persistence (Internal register check)", test_num);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();


            @(posedge clk);
            addr = 8'h40; wd = 8'hCC; we = 1;
            @(posedge clk);


            addr = 8'h40; wd = 8'hDD; we = 0;
            @(posedge clk);


            addr = 8'h40; rae = 1;
            @(posedge clk);
            rae = 0;

            #1;
            $display("Testcase %0d: Write Enable Verification", test_num);
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            @(posedge clk);
            addr = 8'hFF; wd = 8'h99; we = 1;
            @(posedge clk);
            we = 0;

            addr = 8'hFF; rae = 1;
            @(posedge clk);
            rae = 0;

            #1;
            $display("Testcase %0d: Boundary Address (0xFF)", test_num);
            #1;

            check_outputs(8'h99);
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
        input [7:0] expected_rd;
        begin
            if (expected_rd === (expected_rd ^ rd ^ expected_rd)) begin
                $display("PASS");
                $display("  Outputs: rd=%h",
                         rd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd=%h",
                         expected_rd);
                $display("  Got:      rd=%h",
                         rd);
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
        $dumpvars(0,addr, clk, rae, wd, we, rd);
    end

endmodule
