`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr0;
    reg clk;
    reg [15:0] d0;
    reg we0;
    wire [15:0] q0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr0(addr0),
        .clk(clk),
        .d0(d0),
        .we0(we0),
        .q0(q0)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr0 = 0;
            d0 = 0;
            we0 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read at Address 0");
            reset_dut();


            addr0 = 10'h000;
            d0 = 16'hABCD;
            we0 = 1;
            @(posedge clk);

            #1;
            we0 = 0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Writing to Maximum Address Boundary");
            reset_dut();

            addr0 = 10'd1023;
            d0 = 16'hFFFF;
            we0 = 1;
            @(posedge clk);

            #1;
            we0 = 0;
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Verify Write Enable Functionality");
            reset_dut();


            addr0 = 10'h055;
            d0 = 16'h1234;
            we0 = 1;
            @(posedge clk);


            #1;
            d0 = 16'hEEEE;
            we0 = 0;
            @(posedge clk);

            #1;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Successive Overwrite");
            reset_dut();


            addr0 = 10'h0AA;
            d0 = 16'h5555;
            we0 = 1;
            @(posedge clk);


            #1;
            d0 = 16'hAAAA;
            @(posedge clk);

            #1;
            we0 = 0;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Random Access and Persistent Output");
            reset_dut();


            addr0 = 10'd100;
            d0 = 16'h1111;
            we0 = 1;
            @(posedge clk);


            #1;
            addr0 = 10'd200;
            d0 = 16'h2222;
            @(posedge clk);


            #1;
            we0 = 0;
            addr0 = 10'd100;
            #1;

            #1;


            check_outputs(16'h1111);
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
        input [15:0] expected_q0;
        begin
            if (expected_q0 === (expected_q0 ^ q0 ^ expected_q0)) begin
                $display("PASS");
                $display("  Outputs: q0=%h",
                         q0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q0=%h",
                         expected_q0);
                $display("  Got:      q0=%h",
                         q0);
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
        $dumpvars(0,addr0, clk, d0, we0, q0);
    end

endmodule
