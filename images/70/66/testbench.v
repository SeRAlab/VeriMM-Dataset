`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Data;
    reg Href;
    reg Pclk;
    reg Vsync;
    wire [16:0] addr_in;
    wire [7:0] data_in;
    wire regWrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data(Data),
        .Href(Href),
        .Pclk(Pclk),
        .Vsync(Vsync),
        .addr_in(addr_in),
        .data_in(data_in),
        .regWrite(regWrite)
    );

    // Clock generation (10ns period)
    initial begin
        Pclk = 0;
        forever #5 Pclk = ~Pclk;
    end

        task reset_dut;

        begin
            Vsync = 1;
            Href = 0;
            Data = 8'h00;
            @(negedge Pclk);
            Vsync = 0;
            @(negedge Pclk);
            $display("DUT Reset: Vsync pulsed, address should be reset.");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Single Pixel Capture (Bit Mapping)");
            Href = 1;
            Data = 8'hFC;
            @(negedge Pclk);
            Data = 8'h18;
            @(negedge Pclk);

            #1;


            check_outputs(17'd0, 8'hFF, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Address Increment (Two Pixels)");
            Href = 1;

            Data = 8'hAA; @(negedge Pclk);
            Data = 8'h00; @(negedge Pclk);

            Data = 8'h55; @(negedge Pclk);
            Data = 8'h18; @(negedge Pclk);
            #1;

            check_outputs(17'd1, 8'h57, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: regWrite Low during Stage 1");
            Href = 1;
            Data = 8'hFF;
            @(negedge Pclk);
            #1;

            check_outputs(17'd0, 8'hFC, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Vsync Reset Verification");
            Href = 1;

            Data = 8'h00; @(negedge Pclk);
            Data = 8'h00; @(negedge Pclk);

            Vsync = 1; @(negedge Pclk);
            Vsync = 0; @(negedge Pclk);

            Data = 8'hFF; @(negedge Pclk);
            Data = 8'h18; @(negedge Pclk);

            #1;


            check_outputs(17'd0, 8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Href Gating (No capture while Href=0)");
            Href = 0;
            Data = 8'hFF;
            @(negedge Pclk);
            Data = 8'hFF;
            @(negedge Pclk);
            #1;

            check_outputs(17'd0, 8'h00, 1'b0);
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
        input [16:0] expected_addr_in;
        input [7:0] expected_data_in;
        input expected_regWrite;
        begin
            if (expected_addr_in === (expected_addr_in ^ addr_in ^ expected_addr_in) &&
                expected_data_in === (expected_data_in ^ data_in ^ expected_data_in) &&
                expected_regWrite === (expected_regWrite ^ regWrite ^ expected_regWrite)) begin
                $display("PASS");
                $display("  Outputs: addr_in=%h, data_in=%h, regWrite=%b",
                         addr_in, data_in, regWrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr_in=%h, data_in=%h, regWrite=%b",
                         expected_addr_in, expected_data_in, expected_regWrite);
                $display("  Got:      addr_in=%h, data_in=%h, regWrite=%b",
                         addr_in, data_in, regWrite);
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
        $dumpvars(0,Data, Href, Pclk, Vsync, addr_in, data_in, regWrite);
    end

endmodule
