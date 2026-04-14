`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr1;
    reg [7:0] addr2;
    reg clk;
    reg [7:0] din1;
    reg [7:0] din2;
    reg we1;
    reg we2;
    wire [7:0] dout1;
    wire [7:0] dout2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .clk(clk),
        .din1(din1),
        .din2(din2),
        .we1(we1),
        .we2(we2),
        .dout1(dout1),
        .dout2(dout2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we1 = 0;
            we2 = 0;
            din1 = 0;
            din2 = 0;
            addr1 = 0;
            addr2 = 0;
            repeat (2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Testcase 001: Write/Read Port 1");
            @(posedge clk);
            we1 = 1; addr1 = 8'h05; din1 = 8'hAA;
            @(posedge clk);
            we1 = 0; addr1 = 8'h05;
            @(posedge clk);
            #1;

            check_outputs(8'hAA, 8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Testcase 002: Write/Read Port 2");
            @(posedge clk);
            we2 = 1; addr2 = 8'hF0; din2 = 8'h55;
            @(posedge clk);
            we2 = 0; addr2 = 8'hF0;
            @(posedge clk);
            #1;

            check_outputs(8'h00, 8'h55);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Testcase 003: Simultaneous Writes to Different Addresses");
            @(posedge clk);
            we1 = 1; addr1 = 8'h10; din1 = 8'h11;
            we2 = 1; addr2 = 8'h20; din2 = 8'h22;
            @(posedge clk);
            we1 = 0; we2 = 0;
            addr1 = 8'h10; addr2 = 8'h20;
            @(posedge clk);
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Testcase 004: Simultaneous Reads");

            @(posedge clk);
            we1 = 1; addr1 = 8'hA0; din1 = 8'hDE;
            we2 = 1; addr2 = 8'hB0; din2 = 8'hAD;
            @(posedge clk);
            we1 = 0; we2 = 0;

            addr1 = 8'hA0; addr2 = 8'hB0;
            @(posedge clk);
            #1;

            check_outputs(8'hDE, 8'hAD);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Testcase 005: Boundary Address Test");
            @(posedge clk);
            we1 = 1; addr1 = 8'h00; din1 = 8'h01;
            we2 = 1; addr2 = 8'hFF; din2 = 8'hFE;
            @(posedge clk);
            we1 = 0; we2 = 0;
            addr1 = 8'h00; addr2 = 8'hFF;
            @(posedge clk);
            #1;

            check_outputs(8'h01, 8'hFE);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            $display("Testcase 006: Read same address from both ports");
            @(posedge clk);
            we1 = 1; addr1 = 8'h42; din1 = 8'h77;
            @(posedge clk);
            we1 = 0;
            addr1 = 8'h42; addr2 = 8'h42;
            @(posedge clk);
            #1;

            check_outputs(8'h77, 8'h77);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            $display("Testcase 007: Write Port 1, Read Port 2 (different addr)");

            @(posedge clk);
            we2 = 1; addr2 = 8'h88; din2 = 8'h88;
            @(posedge clk);
            we2 = 0;

            we1 = 1; addr1 = 8'h99; din1 = 8'h99;
            addr2 = 8'h88;
            @(posedge clk);
            we1 = 0;
            addr1 = 8'h99;
            @(posedge clk);
            #1;

            check_outputs(8'h99, 8'h88);
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
        input [7:0] expected_dout1;
        input [7:0] expected_dout2;
        begin
            if (expected_dout1 === (expected_dout1 ^ dout1 ^ expected_dout1) &&
                expected_dout2 === (expected_dout2 ^ dout2 ^ expected_dout2)) begin
                $display("PASS");
                $display("  Outputs: dout1=%h, dout2=%h",
                         dout1, dout2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout1=%h, dout2=%h",
                         expected_dout1, expected_dout2);
                $display("  Got:      dout1=%h, dout2=%h",
                         dout1, dout2);
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
        $dumpvars(0,addr1, addr2, clk, din1, din2, we1, we2, dout1, dout2);
    end

endmodule
