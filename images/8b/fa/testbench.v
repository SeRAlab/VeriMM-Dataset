`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] din;
    reg wen;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .wen(wen),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            wen <= 1;
            din <= 8'h00;
            repeat (4) @(posedge clk);
            wen <= 0;
            din <= 8'h00;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic 4-stage shift", test_num);
            reset_dut();

            @(posedge clk);
            wen <= 1; din <= 8'hA1;
            @(posedge clk);
            wen <= 1; din <= 8'hB2;
            @(posedge clk);
            wen <= 1; din <= 8'hC3;
            @(posedge clk);
            wen <= 1; din <= 8'hD4;

            #1;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable gating test", test_num);
            reset_dut();

            @(posedge clk);
            wen <= 1; din <= 8'h11;
            @(posedge clk);
            wen <= 1; din <= 8'h22;
            @(posedge clk);
            wen <= 0; din <= 8'hFF;
            @(posedge clk);
            wen <= 0; din <= 8'hEE;
            @(posedge clk);
            wen <= 1; din <= 8'h33;
            @(posedge clk);
            wen <= 1; din <= 8'h44;

            #1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Continuous stream (5 cycles)", test_num);
            reset_dut();

            @(posedge clk);
            wen <= 1; din <= 8'h01;
            @(posedge clk);
            wen <= 1; din <= 8'h02;
            @(posedge clk);
            wen <= 1; din <= 8'h03;
            @(posedge clk);
            wen <= 1; din <= 8'h04;
            @(posedge clk);
            wen <= 1; din <= 8'h05;

            #1;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Output persistence", test_num);
            reset_dut();

            @(posedge clk);
            wen <= 1; din <= 8'h99;
            @(posedge clk);
            wen <= 1; din <= 8'h88;
            @(posedge clk);
            wen <= 1; din <= 8'h77;
            @(posedge clk);
            wen <= 1; din <= 8'h66;
            @(posedge clk);
            wen <= 0; din <= 8'h00;

            repeat (3) @(posedge clk);

            #1;
            #1;

            check_outputs(8'h99);
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
        input [7:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,clk, din, wen, dout);
    end

endmodule
