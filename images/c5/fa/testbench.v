`timescale 1ns/1ps

module data_pass_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] data_in;
    wire [23:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_pass_module dut (
        .clk(clk),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in = 24'h000000;
            @(posedge clk);
            @(negedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Testing All Zeros (0x000000)", test_num);
            reset_dut();
            data_in = 24'h000000;
            @(posedge clk);
            @(negedge clk);
            #2;
            #1;

            check_outputs(24'h000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing All Ones (0xFFFFFF)", test_num);
            reset_dut();
            data_in = 24'hFFFFFF;
            @(posedge clk);
            @(negedge clk);
            #2;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing Pattern 0x555555", test_num);
            reset_dut();
            data_in = 24'h555555;
            @(posedge clk);
            @(negedge clk);
            #2;
            #1;

            check_outputs(24'h555555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Testing Pattern 0xAAAAAA", test_num);
            reset_dut();
            data_in = 24'hAAAAAA;
            @(posedge clk);
            @(negedge clk);
            #2;
            #1;

            check_outputs(24'hAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing Pattern 0x123456", test_num);
            reset_dut();
            data_in = 24'h123456;
            @(posedge clk);
            @(negedge clk);
            #2;
            #1;

            check_outputs(24'h123456);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Testing Pattern 0xFF00AA", test_num);
            reset_dut();
            data_in = 24'hFF00AA;
            @(posedge clk);
            @(negedge clk);
            #2;
            #1;

            check_outputs(24'hFF00AA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_pass_module Testbench");
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
        input [23:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, data_out);
    end

endmodule
