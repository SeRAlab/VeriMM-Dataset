`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [31:0] indata;
    reg [31:0] indata180;
    wire [31:0] outdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .indata(indata),
        .indata180(indata180),
        .outdata(outdata)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            indata = 32'h0;
            indata180 = 32'h0;
            repeat (3) @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic functional combination", test_num);
            reset_dut();


            indata = 32'hAAAAAAAA;
            indata180 = 32'hFFFFFFFF;
            @(posedge clock); #1;


            indata = 32'h55555555;
            indata180 = 32'hFFFFFFFF;
            @(posedge clock); #1;

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Feedback accumulation", test_num);
            reset_dut();

            indata180 = 32'hFFFFFFFF;


            indata = 32'h00000001; @(posedge clock); #1;

            indata = 32'h00000002; @(posedge clock); #1;

            indata = 32'h00000004; @(posedge clock); #1;

            indata = 32'h00000008; @(posedge clock); #1;

            #1;


            check_outputs(32'h0000000F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Masking via indata180 delay", test_num);
            reset_dut();


            indata = 32'hFFFFFFFF;
            indata180 = 32'h0000FFFF;
            @(posedge clock); #1;

            indata = 32'h00000000;
            indata180 = 32'h00000000;
            @(posedge clock); #1;

            #1;


            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All bits high check", test_num);
            reset_dut();

            indata = 32'hFFFF0000;
            indata180 = 32'hFFFFFFFF;
            @(posedge clock); #1;

            indata = 32'h0000FFFF;
            indata180 = 32'hFFFFFFFF;
            @(posedge clock); #1;

            #1;


            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex bitwise masking", test_num);
            reset_dut();


            indata = 32'h55555555;
            indata180 = 32'hFFFFFFFF;
            @(posedge clock); #1;


            indata = 32'hAAAAAAAA;
            indata180 = 32'h0F0F0F0F;
            @(posedge clock); #1;


            indata = 32'h00000000;
            indata180 = 32'h00000000;
            @(posedge clock); #1;

            #1;


            check_outputs(32'h0F0F0F0F);
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
        input [31:0] expected_outdata;
        begin
            if (expected_outdata === (expected_outdata ^ outdata ^ expected_outdata)) begin
                $display("PASS");
                $display("  Outputs: outdata=%h",
                         outdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: outdata=%h",
                         expected_outdata);
                $display("  Got:      outdata=%h",
                         outdata);
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
        $dumpvars(0,clock, indata, indata180, outdata);
    end

endmodule
