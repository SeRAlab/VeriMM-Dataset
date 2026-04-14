`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg address;
    reg clock;
    reg reset_n;
    wire [31:0] readdata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .reset_n(reset_n),
        .readdata(readdata)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address = 0;
            reset_n = 0;
            @(negedge clock);
            reset_n = 1;
            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Verifying Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Address high (Expect 1423170505)", test_num);
            reset_dut();
            address = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'd1423170505);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Address low (Expect 0)", test_num);
            reset_dut();
            address = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Transition Address 1 -> 0", test_num);
            reset_dut();
            address = 1;
            @(posedge clock);
            #1;
            address = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Transition Address 0 -> 1", test_num);
            reset_dut();
            address = 0;
            @(posedge clock);
            #1;
            address = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'd1423170505);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Sustained Address High", test_num);
            reset_dut();
            address = 1;
            @(posedge clock);
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(32'd1423170505);
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
        input [31:0] expected_readdata;
        begin
            if (expected_readdata === (expected_readdata ^ readdata ^ expected_readdata)) begin
                $display("PASS");
                $display("  Outputs: readdata=%h",
                         readdata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: readdata=%h",
                         expected_readdata);
                $display("  Got:      readdata=%h",
                         readdata);
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
        $dumpvars(0,address, clock, reset_n, readdata);
    end

endmodule
