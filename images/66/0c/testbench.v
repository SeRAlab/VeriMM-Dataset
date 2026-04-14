`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    wire [7:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data(data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            addr = 4'd0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking addr 0 ('H')", test_num);
            #1;

            check_outputs(8'h48);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            addr = 4'd4;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking addr 4 ('o')", test_num);
            #1;

            check_outputs(8'h6F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            addr = 4'd5;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking addr 5 (' ')", test_num);
            #1;

            check_outputs(8'h20);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            addr = 4'd6;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking addr 6 ('W')", test_num);
            #1;

            check_outputs(8'h57);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            addr = 4'd11;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking addr 11 ('!')", test_num);
            #1;

            check_outputs(8'h21);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            addr = 4'd12;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking addr 12 ('\\n')", test_num);
            #1;

            check_outputs(8'h0A);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            addr = 4'd13;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking addr 13 ('\\r')", test_num);
            #1;

            check_outputs(8'h0D);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            addr = 4'd15;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking out-of-range addr 15 (Space)", test_num);
            #1;

            check_outputs(8'h20);
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
        testcase008();
        
        
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
        input [7:0] expected_data;
        begin
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
        $dumpvars(0,addr, clk, data);
    end

endmodule
