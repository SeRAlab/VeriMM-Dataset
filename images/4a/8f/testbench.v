`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] addr_i;
    reg [6:0] addr_o;
    reg clk;
    reg [15:0] data_i;
    wire [15:0] data_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_i(addr_i),
        .addr_o(addr_o),
        .clk(clk),
        .data_i(data_i),
        .data_o(data_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr_i = 0;
            addr_o = 0;
            data_i = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase001: Write and Read at Addr 0...");


            addr_i = 7'd0;
            data_i = 16'hAAAA;
            @(negedge clk);


            @(posedge clk);
            addr_o = 7'd0;
            @(negedge clk);

            #2;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase002: Write and Read at Addr 127...");

            addr_i = 7'd127;
            data_i = 16'h5555;
            @(negedge clk);

            @(posedge clk);
            addr_o = 7'd127;
            @(negedge clk);

            #2;
            #1;

            check_outputs(16'h5555);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase003: Multiple sequential writes...");


            addr_i = 7'd10; data_i = 16'h1234;
            @(negedge clk);


            @(posedge clk);
            addr_i = 7'd20; data_i = 16'h5678;
            @(negedge clk);


            @(posedge clk);
            addr_o = 7'd10;
            @(negedge clk);

            #2;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase004: Simultaneous Read/Write...");


            addr_i = 7'd50; data_i = 16'hDEAF;
            @(negedge clk);


            @(posedge clk);
            addr_i = 7'd60; data_i = 16'hBEEF;
            addr_o = 7'd50;
            @(negedge clk);

            #2;
            #1;

            check_outputs(16'hDEAF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase005: Overwrite check...");


            addr_i = 7'd33; data_i = 16'h1111;
            @(negedge clk);


            @(posedge clk);
            addr_i = 7'd33; data_i = 16'h2222;
            @(negedge clk);


            @(posedge clk);
            addr_o = 7'd33;
            @(negedge clk);

            #2;
            #1;

            check_outputs(16'h2222);
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
        input [15:0] expected_data_o;
        begin
            if (expected_data_o === (expected_data_o ^ data_o ^ expected_data_o)) begin
                $display("PASS");
                $display("  Outputs: data_o=%h",
                         data_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_o=%h",
                         expected_data_o);
                $display("  Got:      data_o=%h",
                         data_o);
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
        $dumpvars(0,addr_i, addr_o, clk, data_i, data_o);
    end

endmodule
