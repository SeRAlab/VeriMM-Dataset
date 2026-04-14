`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] data_in;
    wire clk;
    wire [15:0] data_out;
    wire load;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .clk(clk),
        .data_out(data_out),
        .load(load)
    );

        task reset_dut;

        begin
            load = 0;
            data_in = 16'h0000;
            @(negedge clk);
            load = 1;
            data_in = 16'h0000;
            @(posedge clk);
            #2;
            load = 0;
            $display("DUT Initialized");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Basic Parallel Load (0xABCD)", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 16'hABCD;
            load = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 16'hABCD, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Hold Value (Load=0)", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 16'h5555;
            load = 1;
            @(posedge clk);
            #2;


            @(negedge clk);
            data_in = 16'hAAAA;
            load = 0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 16'h5555, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Load All Ones (0xFFFF)", test_num);
            reset_dut();

            @(negedge clk);
            data_in = 16'hFFFF;
            load = 1;

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 16'hFFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Successive Loads", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 16'h1234;
            load = 1;
            @(posedge clk);
            #2;


            @(negedge clk);
            data_in = 16'h8765;
            load = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 16'h8765, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Input Change while Load is Low", test_num);
            reset_dut();


            @(negedge clk);
            data_in = 16'h1111;
            load = 1;
            @(posedge clk);
            #2;


            @(negedge clk);
            load = 0;
            data_in = 16'h2222;
            @(posedge clk);
            #2;
            @(negedge clk);
            data_in = 16'h3333;
            @(posedge clk);
            #2;


            #1;



            check_outputs(1'b1, 16'h1111, 1'b0);
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
        input expected_clk;
        input [15:0] expected_data_out;
        input expected_load;
        begin
            if (expected_clk === (expected_clk ^ clk ^ expected_clk) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_load === (expected_load ^ load ^ expected_load)) begin
                $display("PASS");
                $display("  Outputs: clk=%b, data_out=%h, load=%b",
                         clk, data_out, load);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk=%b, data_out=%h, load=%b",
                         expected_clk, expected_data_out, expected_load);
                $display("  Got:      clk=%b, data_out=%h, load=%b",
                         clk, data_out, load);
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
        $dumpvars(0,data_in, clk, data_out, load);
    end

endmodule
