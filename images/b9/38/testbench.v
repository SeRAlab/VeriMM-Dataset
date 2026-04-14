`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] afl;
    reg [31:0] bfl;
    reg clk;
    reg rstn;
    wire [31:0] fl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .afl(afl),
        .bfl(bfl),
        .clk(clk),
        .rstn(rstn),
        .fl(fl)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            afl = 0;
            bfl = 0;
            repeat (5) @(posedge clk);
            rstn = 1;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: 1.0 * 1.0", test_num);
            afl = 32'h3F800000;
            bfl = 32'h3F800000;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(32'h3F800000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: 2.0 * 3.0", test_num);
            afl = 32'h40000000;
            bfl = 32'h40400000;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(32'h40C00000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: 2.0 * -3.0", test_num);
            afl = 32'h40000000;
            bfl = 32'hC0400000;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(32'hC0C00000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: 1.5 * 1.5", test_num);
            afl = 32'h3FC00000;
            bfl = 32'h3FC00000;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(32'h40100000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: 0.0 * 5.0", test_num);
            afl = 32'h00000000;
            bfl = 32'h40A00000;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: 0.5 * 0.5", test_num);
            afl = 32'h3F000000;
            bfl = 32'h3F000000;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(32'h3E800000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: 1024.0 * 2048.0", test_num);
            afl = 32'h44800000;
            bfl = 32'h45000000;
            repeat (10) @(posedge clk);
            #1;

            check_outputs(32'h4A000000);
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
        input [31:0] expected_fl;
        begin
            if (expected_fl === (expected_fl ^ fl ^ expected_fl)) begin
                $display("PASS");
                $display("  Outputs: fl=%h",
                         fl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fl=%h",
                         expected_fl);
                $display("  Got:      fl=%h",
                         fl);
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
        $dumpvars(0,afl, bfl, clk, rstn, fl);
    end

endmodule
