`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Load;
    reg clk;
    reg [33:0] data_in;
    reg rstn;
    wire [33:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Load(Load),
        .clk(clk),
        .data_in(data_in),
        .rstn(rstn),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rstn = 0;
            Load = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            rstn = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Check Reset Value", test_num);
            reset_dut();

            #1;


            check_outputs(34'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Load Functionality", test_num);
            reset_dut();
            data_in = 34'h2AAAAAAAA;
            Load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(34'h2AAAAAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold Functionality", test_num);
            reset_dut();

            data_in = 34'h355555555;
            Load = 1;
            @(posedge clk);
            #1;

            Load = 0;
            data_in = 34'h000000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(34'h355555555);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Max Value", test_num);
            reset_dut();
            data_in = 34'h3FFFFFFFF;
            Load = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(34'h3FFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Successive Loads", test_num);
            reset_dut();
            Load = 1;
            data_in = 34'h123456789;
            @(posedge clk);
            #1;
            data_in = 34'h3EFEFEFEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(34'h3EFEFEFEF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load Transition Check", test_num);
            reset_dut();
            data_in = 34'h00C0FFEE0;
            Load = 1;
            @(posedge clk);
            #1;
            data_in = 34'h00DEADBEE;
            Load = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(34'h00C0FFEE0);
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
        input [33:0] expected_data_out;
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
        $dumpvars(0,Load, clk, data_in, rstn, data_out);
    end

endmodule
