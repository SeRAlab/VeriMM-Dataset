`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] address;
    reg clk;
    reg [15:0] data_in;
    reg rst;
    reg write_en;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .write_en(write_en),
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
            write_en = 0;
            address = 0;
            data_in = 0;
            repeat (2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            address = 10'h010;
            data_in = 16'hABCD;
            write_en = 1;
            @(posedge clk);


            write_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address (Max)", test_num);
            reset_dut();


            @(posedge clk);
            address = 10'h3FF;
            data_in = 16'h55AA;
            write_en = 1;
            @(posedge clk);


            write_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address (Zero)", test_num);
            reset_dut();


            @(posedge clk);
            address = 10'h000;
            data_in = 16'h1234;
            write_en = 1;
            @(posedge clk);


            write_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Data", test_num);
            reset_dut();


            @(posedge clk);
            address = 10'h0A5;
            data_in = 16'h1111;
            write_en = 1;
            @(posedge clk);


            data_in = 16'h2222;
            @(posedge clk);


            write_en = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h2222);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Output Initialization", test_num);


            reset_dut();
            @(posedge clk);
            address = 10'h020;
            data_in = 16'hFFFF;
            write_en = 1;
            @(posedge clk);
            write_en = 0;
            @(posedge clk);


            rst = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
            rst = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sequential Writes / Selective Read", test_num);
            reset_dut();

            @(posedge clk);
            write_en = 1;


            address = 10'h001; data_in = 16'h1001;
            @(posedge clk);


            address = 10'h002; data_in = 16'h2002;
            @(posedge clk);


            address = 10'h003; data_in = 16'h3003;
            @(posedge clk);


            write_en = 0;
            address = 10'h002;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h2002);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,address, clk, data_in, rst, write_en, data_out);
    end

endmodule
