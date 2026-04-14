`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg dest_clk;
    reg dest_resetn;
    reg [7:0] source_data;
    wire [7:0] dest_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dest_clk(dest_clk),
        .dest_resetn(dest_resetn),
        .source_data(source_data),
        .dest_data(dest_data)
    );

    // Clock generation (10ns period)
    initial begin
        dest_clk = 0;
        forever #5 dest_clk = ~dest_clk;
    end

        task reset_dut;

        begin
            dest_resetn = 0;
            source_data = 8'h00;
            repeat(2) @(posedge dest_clk);
            #1;
            dest_resetn = 1;
            @(posedge dest_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Propagation (2 clock cycles)", test_num);
            reset_dut();
            source_data = 8'hA5;

            repeat(2) @(posedge dest_clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Pipeline Latency Check (1 clock cycle)", test_num);
            reset_dut();
            source_data = 8'h5A;
            @(posedge dest_clk);
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Full Bit Width Check (0xFF)", test_num);
            reset_dut();
            source_data = 8'hFF;
            repeat(2) @(posedge dest_clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Sequential Data Flow", test_num);
            reset_dut();
            source_data = 8'h11;
            @(posedge dest_clk);
            source_data = 8'h22;
            @(posedge dest_clk);
            #1;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset Priority Mid-Operation", test_num);
            reset_dut();
            source_data = 8'hCC;
            repeat(2) @(posedge dest_clk);
            #1;
            dest_resetn = 0;
            #2;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_dest_data;
        begin
            if (expected_dest_data === (expected_dest_data ^ dest_data ^ expected_dest_data)) begin
                $display("PASS");
                $display("  Outputs: dest_data=%h",
                         dest_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dest_data=%h",
                         expected_dest_data);
                $display("  Got:      dest_data=%h",
                         dest_data);
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
        $dumpvars(0,dest_clk, dest_resetn, source_data, dest_data);
    end

endmodule
