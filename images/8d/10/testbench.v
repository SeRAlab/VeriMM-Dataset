`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg ld;
    wire lz;
    wire [7:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .ld(ld),
        .lz(lz),
        .z(z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ld = 0;
            d = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            d = 8'hA5;
            ld = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            d = 8'hAA; ld = 1;
            @(posedge clk);
            #1;

            d = 8'hAA; ld = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            d = 8'h11; ld = 1;
            @(posedge clk);
            #1;

            d = 8'hEE; ld = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'hEE);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            d = 8'h55; ld = 1;
            @(posedge clk);
            #1;

            d = 8'hFF; ld = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            d = 8'hFF; ld = 1;
            @(posedge clk);
            #1;

            d = 8'h00; ld = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h00);
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
        input expected_lz;
        input [7:0] expected_z;
        begin
            if (expected_lz === (expected_lz ^ lz ^ expected_lz) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: lz=%b, z=%h",
                         lz, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lz=%b, z=%h",
                         expected_lz, expected_z);
                $display("  Got:      lz=%b, z=%h",
                         lz, z);
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
        $dumpvars(0,clk, d, ld, lz, z);
    end

endmodule
