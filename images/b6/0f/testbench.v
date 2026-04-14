`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] data_in;
    reg rst;
    reg wena;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .wena(wena),
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
            wena = 0;
            data_in = 0;
            #12;
            rst = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Verify Asynchronous Reset", test_num);
            reset_dut();
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Write (wena=1, negedge)", test_num);
            reset_dut();
            @(negedge clk);
            wena = 1;
            data_in = 32'hDEADBEEF;
            @(negedge clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Write Enable Disable (wena=0)", test_num);
            reset_dut();

            @(negedge clk);
            wena = 1;
            data_in = 32'hAAAA5555;
            @(negedge clk);

            wena = 0;
            data_in = 32'hFFFFFFFF;
            @(negedge clk);
            #2;
            #1;

            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Verify Negative Edge Triggering Only", test_num);
            reset_dut();
            @(posedge clk);
            wena = 1;
            data_in = 32'h12345678;
            #2;

            if (data_out !== 32'h00000000) begin
                $display("FAIL: Data updated on Positive Edge!");
            end
            @(negedge clk);
            #2;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Mid-cycle Asynchronous Reset", test_num);
            reset_dut();
            @(negedge clk);
            wena = 1;
            data_in = 32'h87654321;
            @(negedge clk);
            #2;
            rst = 1;
            #1;
            #1;

            check_outputs(32'h00000000);
            rst = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Multiple Continuous Writes", test_num);
            reset_dut();
            wena = 1;
            @(negedge clk);
            data_in = 32'h11111111;
            @(negedge clk);
            data_in = 32'h22222222;
            @(negedge clk);
            data_in = 32'h33333333;
            @(negedge clk);
            #2;
            #1;

            check_outputs(32'h33333333);
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
        input [31:0] expected_data_out;
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
        $dumpvars(0,clk, data_in, rst, wena, data_out);
    end

endmodule
