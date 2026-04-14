`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg divs;
    reg [31:0] pcpi_rs2;
    reg resetn;
    wire [62:0] divisor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .divs(divs),
        .pcpi_rs2(pcpi_rs2),
        .resetn(resetn),
        .divisor(divisor)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            divs = 0;
            pcpi_rs2 = 0;
            @(posedge clk);
            #1;
            resetn = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            divs = 1;
            pcpi_rs2 = 32'h0000_0005;
            @(posedge clk);
            #1;
            #1;

            check_outputs(63'h0000_0002_8000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            divs = 1;
            pcpi_rs2 = 32'hFFFF_FFFB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(63'h0000_0002_8000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            divs = 0;
            pcpi_rs2 = 32'hFFFF_FFFB;
            @(posedge clk);
            #1;
            #1;

            check_outputs(63'h7FFF_FFFD_8000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            divs = 1;
            pcpi_rs2 = 32'h8000_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(63'h4000_0000_0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            divs = 1;
            pcpi_rs2 = 32'h7FFF_FFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(63'h3FFF_FFFF_8000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            divs = 1;
            pcpi_rs2 = 32'h0000_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(63'h0000_0000_0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            divs = 1;
            pcpi_rs2 = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(63'h0000_0000_8000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            divs = 0;
            pcpi_rs2 = 32'h8000_0001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(63'h4000_0000_8000_0000);
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
        input [62:0] expected_divisor;
        begin
            if (expected_divisor === (expected_divisor ^ divisor ^ expected_divisor)) begin
                $display("PASS");
                $display("  Outputs: divisor=%h",
                         divisor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: divisor=%h",
                         expected_divisor);
                $display("  Got:      divisor=%h",
                         divisor);
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
        $dumpvars(0,clk, divs, pcpi_rs2, resetn, divisor);
    end

endmodule
