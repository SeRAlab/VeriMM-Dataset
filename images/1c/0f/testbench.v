`timescale 1ns/1ps

module DRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] din;
    reg re;
    reg we;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DRAM_Cell dut (
        .clk(clk),
        .din(din),
        .re(re),
        .we(we),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            re = 0;
            din = 16'h0000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read");
            reset_dut();


            din = 16'hABCD;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;


            re = 1;
            #1;
            test_num = test_num + 1;
            #1;

            check_outputs(16'hABCD);
            re = 0;
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Data Retention Check");
            reset_dut();


            din = 16'h1234;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            din = 16'hFFFF;
            @(posedge clk);
            #1;


            re = 1;
            #1;
            test_num = test_num + 1;
            #1;

            check_outputs(16'h1234);
            re = 0;
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Overwriting Data");
            reset_dut();


            din = 16'h5555;
            we = 1;
            @(posedge clk);
            #1;


            din = 16'hAAAA;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;


            re = 1;
            #1;
            test_num = test_num + 1;
            #1;

            check_outputs(16'hAAAA);
            re = 0;
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: All Zeros");
            reset_dut();

            din = 16'h0000;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;

            re = 1;
            #1;
            test_num = test_num + 1;
            #1;

            check_outputs(16'h0000);
            re = 0;
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: All Ones");
            reset_dut();

            din = 16'hFFFF;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;

            re = 1;
            #1;
            test_num = test_num + 1;
            #1;

            check_outputs(16'hFFFF);
            re = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DRAM_Cell Testbench");
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
        input [15:0] expected_dout;
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
        $dumpvars(0,clk, din, re, we, dout);
    end

endmodule
