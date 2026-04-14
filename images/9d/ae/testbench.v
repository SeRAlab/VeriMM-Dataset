`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg ck;
    reg [7:0] d;
    reg rst_n;
    wire [7:0] q1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ck(ck),
        .d(d),
        .rst_n(rst_n),
        .q1(q1)
    );

    // Clock generation (10ns period)
    initial begin
        ck = 0;
        forever #5 ck = ~ck;
    end

        task reset_dut;

        begin
            @(negedge ck);
            rst_n = 0;
            d = 8'h00;
            @(negedge ck);
            rst_n = 1;
            @(negedge ck);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Data Load 0xAA", test_num);
            reset_dut();
            @(negedge ck);
            d = 8'hAA;
            @(posedge ck);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Data Load 0x55", test_num);
            reset_dut();
            @(negedge ck);
            d = 8'h55;
            @(posedge ck);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load All Bits High (0xFF)", test_num);
            reset_dut();
            @(negedge ck);
            d = 8'hFF;
            @(posedge ck);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset Priority Over Data", test_num);
            reset_dut();
            @(negedge ck);
            d = 8'hFF;
            rst_n = 0;
            @(posedge ck);
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Persistence/Edge Sensitivity", test_num);
            reset_dut();
            @(negedge ck);
            d = 8'hC3;
            @(posedge ck);
            #1;
            d = 8'h00;
            #2;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Data Loading", test_num);
            reset_dut();
            @(negedge ck);
            d = 8'h11;
            @(posedge ck);
            #1;
            @(negedge ck);
            d = 8'h22;
            @(posedge ck);
            #1;
            @(negedge ck);
            d = 8'h33;
            @(posedge ck);
            #1;
            #1;

            check_outputs(8'h33);
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
        input [7:0] expected_q1;
        begin
            if (expected_q1 === (expected_q1 ^ q1 ^ expected_q1)) begin
                $display("PASS");
                $display("  Outputs: q1=%h",
                         q1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q1=%h",
                         expected_q1);
                $display("  Got:      q1=%h",
                         q1);
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
        $dumpvars(0,ck, d, rst_n, q1);
    end

endmodule
