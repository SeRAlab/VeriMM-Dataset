`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] In0;
    reg [1:0] In1;
    reg clk;
    wire [9:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In0(In0),
        .In1(In1),
        .clk(clk),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            In0 = 8'h0;
            In1 = 2'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: All Zeros");
            reset_dut();
            In0 = 8'h00;
            In1 = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All Ones");
            reset_dut();
            In0 = 8'hFF;
            In1 = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Alternating Bits Pattern 1");
            reset_dut();
            In0 = 8'hAA;
            In1 = 2'b01;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'h1AA);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Alternating Bits Pattern 2");
            reset_dut();
            In0 = 8'h55;
            In1 = 2'b10;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'h255);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: MSB and LSB logic checks");
            reset_dut();
            In0 = 8'h01;
            In1 = 2'b11;
            @(posedge clk);
            #1;

            #1;


            check_outputs(10'h301);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Data transition check");
            reset_dut();

            In0 = 8'hF0;
            In1 = 2'b00;
            @(posedge clk);
            #1;

            In0 = 8'h0F;
            In1 = 2'b11;

            #1;


            check_outputs(10'h0F0);


            @(posedge clk);
            #1;

            #1;


            check_outputs(10'h30F);
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
        input [9:0] expected_dout;
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
        $dumpvars(0,In0, In1, clk, dout);
    end

endmodule
