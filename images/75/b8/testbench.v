`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start;
    reg [7:0] vin;
    wire busy;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .vin(vin),
        .busy(busy),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            vin = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task run_conversion;

        input [7:0] value;
        begin
            vin = value;
            @(posedge clk);
            #1 start = 1;

            wait(busy == 1);

            repeat(12) @(posedge clk);
            #1 start = 0;

            wait(busy == 0);
            @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Vin = 0", test_num);
            reset_dut();
            run_conversion(8'd0);
            #1;

            check_outputs(1'b0, 8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Vin = 255", test_num);
            reset_dut();
            run_conversion(8'd255);
            #1;

            check_outputs(1'b0, 8'd255);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Vin = 128", test_num);
            reset_dut();
            run_conversion(8'd128);
            #1;

            check_outputs(1'b0, 8'd128);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Vin = 170 (0xAA)", test_num);
            reset_dut();
            run_conversion(8'd170);
            #1;

            check_outputs(1'b0, 8'd170);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Running Testcase %03d: Vin = 85 (0x55)", test_num);
            reset_dut();
            run_conversion(8'd85);
            #1;

            check_outputs(1'b0, 8'd85);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Running Testcase %03d: Vin = 200", test_num);
            reset_dut();
            run_conversion(8'd200);
            #1;

            check_outputs(1'b0, 8'd200);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Running Testcase %03d: Vin = 10", test_num);
            reset_dut();
            run_conversion(8'd10);
            #1;

            check_outputs(1'b0, 8'd10);
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
        input expected_busy;
        input [7:0] expected_dout;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, dout=%h",
                         busy, dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, dout=%h",
                         expected_busy, expected_dout);
                $display("  Got:      busy=%b, dout=%h",
                         busy, dout);
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
        $dumpvars(0,clk, reset, start, vin, busy, dout);
    end

endmodule
