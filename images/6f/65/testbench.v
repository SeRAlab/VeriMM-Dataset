`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] pad;
    wire [31:0] indata;
    wire [31:0] indata180;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pad(pad),
        .indata(indata),
        .indata180(indata180)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            pad = 0;


            @(negedge clk);
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Basic DDR-style capture", test_num);


            pad = 32'h12345678;
            @(posedge clk);
            #1;


            pad = 32'h87654321;
            @(negedge clk);
            #1;


            #1;



            check_outputs(32'h12345678, 32'h87654321);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: All ones and All zeros capture", test_num);

            pad = 32'hFFFFFFFF;
            @(posedge clk);
            #1;

            pad = 32'h00000000;
            @(negedge clk);
            #1;

            #1;


            check_outputs(32'hFFFFFFFF, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Data changing multiple times", test_num);


            pad = 32'hAAAAAAAA;
            @(posedge clk);
            #1;


            pad = 32'h11111111; #1;
            pad = 32'h22222222; #1;
            pad = 32'hBBBBBBBB;
            @(negedge clk);
            #1;

            #1;


            check_outputs(32'hAAAAAAAA, 32'hBBBBBBBB);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Checkerboard pattern", test_num);

            pad = 32'h5555AAAA;
            @(posedge clk);
            #1;

            pad = 32'hAAAA5555;
            @(negedge clk);
            #1;

            #1;


            check_outputs(32'h5555AAAA, 32'hAAAA5555);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Persistence check", test_num);


            pad = 32'h11223344;
            @(posedge clk);
            pad = 32'h55667788;
            @(negedge clk);


            pad = 32'hEEEEEEEE;
            #2;


            #1;



            check_outputs(32'h11223344, 32'h55667788);
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
        input [31:0] expected_indata;
        input [31:0] expected_indata180;
        begin
            if (expected_indata === (expected_indata ^ indata ^ expected_indata) &&
                expected_indata180 === (expected_indata180 ^ indata180 ^ expected_indata180)) begin
                $display("PASS");
                $display("  Outputs: indata=%h, indata180=%h",
                         indata, indata180);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: indata=%h, indata180=%h",
                         expected_indata, expected_indata180);
                $display("  Got:      indata=%h, indata180=%h",
                         indata, indata180);
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
        $dumpvars(0,clk, pad, indata, indata180);
    end

endmodule
