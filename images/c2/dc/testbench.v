`timescale 1ns/1ps

module encryption_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg [15:0] key;
    reg rst;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encryption_module dut (
        .clk(clk),
        .data_in(data_in),
        .key(key),
        .rst(rst),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 0;
            key = 0;
            @(posedge clk);
            #1;
            rst = 0;


            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity XOR (Key=0)", test_num);
            reset_dut();
            data_in = 8'hA5;
            key = 16'h0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic XOR (Key=0x00FF)", test_num);
            reset_dut();
            data_in = 8'h55;
            key = 16'h00FF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Key Truncation (Key=0x1234)", test_num);
            reset_dut();
            data_in = 8'h00;
            key = 16'h1234;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h34);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Data Stream", test_num);
            reset_dut();


            data_in = 8'h11;
            key = 16'h0001;
            @(posedge clk);


            data_in = 8'h22;
            key = 16'h0002;
            @(posedge clk);

            #2;
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset Priority", test_num);
            reset_dut();

            data_in = 8'hFF;
            key = 16'h0000;
            @(posedge clk);

            #1 rst = 1;
            data_in = 8'hAA;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'h00);
            rst = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones XOR", test_num);
            reset_dut();
            data_in = 8'hFF;
            key = 16'hFFFF;
            @(posedge clk);
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
        $display("encryption_module Testbench");
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
        input [7:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, key, rst, data_out);
    end

endmodule
