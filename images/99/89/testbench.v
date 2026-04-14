`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [23:0] data_in;
    wire [23:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
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
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Loading all ones (24'hFFFFFF)", test_num);
            data_in = 24'hFFFFFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Loading checkerboard pattern (24'hAAAAAA)", test_num);
            data_in = 24'hAAAAAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'hAAAAAA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Loading inverse checkerboard pattern (24'h555555)", test_num);
            data_in = 24'h555555;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h555555);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Loading sequential hex pattern (24'h123456)", test_num);
            data_in = 24'h123456;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h123456);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Loading bit 0 high (24'h000001)", test_num);
            data_in = 24'h000001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h000001);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Loading bit 23 high (24'h800000)", test_num);
            data_in = 24'h800000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(24'h800000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %0d: Verifying data hold between clock edges", test_num);
            data_in = 24'hABCDEF;
            @(posedge clk);
            #2;

            data_in = 24'h000000;
            #5;

            #1;


            check_outputs(24'hABCDEF);
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
