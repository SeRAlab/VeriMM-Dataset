`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk80;
    reg [4:0] din;
    reg enable;
    reg reset;
    wire [3:0] dout;
    wire error;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk80(clk80),
        .din(din),
        .enable(enable),
        .reset(reset),
        .dout(dout),
        .error(error)
    );

    // Clock generation (10ns period)
    initial begin
        clk80 = 0;
        forever #5 clk80 = ~clk80;
    end

        task reset_dut;

        begin
            reset = 1;
            enable = 0;
            din = 5'b00000;
            @(posedge clk80);
            #1 reset = 0;
            @(posedge clk80);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            enable = 1;
            din = 5'b11110;
            @(posedge clk80);
            #1 #1;
 check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            enable = 1;
            din = 5'b01011;
            @(posedge clk80);
            #1 #1;
 check_outputs(4'h5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            enable = 1;
            din = 5'b10110;
            @(posedge clk80);
            #1 #1;
 check_outputs(4'hA, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            enable = 1;
            din = 5'b11101;
            @(posedge clk80);
            #1 #1;
 check_outputs(4'hF, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            enable = 1;
            din = 5'b00000;
            @(posedge clk80);
            #1 #1;
 check_outputs(dout, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            enable = 1;
            din = 5'b11111;
            @(posedge clk80);
            #1 #1;
 check_outputs(dout, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();

            enable = 1;
            din = 5'b11110;
            @(posedge clk80);
            #1;

            enable = 0;
            din = 5'b01011;
            @(posedge clk80);
            #1 #1;
 check_outputs(4'h0, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            enable = 1;
            din = 5'b01111;
            @(posedge clk80);
            #1 #1;
 check_outputs(4'h7, 1'b0);
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
        input [3:0] expected_dout;
        input expected_error;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout) &&
                expected_error === (expected_error ^ error ^ expected_error)) begin
                $display("PASS");
                $display("  Outputs: dout=%h, error=%b",
                         dout, error);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h, error=%b",
                         expected_dout, expected_error);
                $display("  Got:      dout=%h, error=%b",
                         dout, error);
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
        $dumpvars(0,clk80, din, enable, reset, dout, error);
    end

endmodule
