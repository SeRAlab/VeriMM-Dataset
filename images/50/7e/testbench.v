`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] addr;
    reg [1:0] byteExt;
    reg clk;
    reg [31:0] din;
    reg [1:0] wEn;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .byteExt(byteExt),
        .clk(clk),
        .din(din),
        .wEn(wEn),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            byteExt = 0;
            din = 0;
            wEn = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            addr = 12'h000;
            din = 32'hAABBCCDD;
            wEn = 2'b10;
            @(posedge clk);
            #1;
            wEn = 2'b00;
            byteExt = 2'b00;
            #2;
            $display("Testcase 001: Word Write/Read");
            #1;

            check_outputs(32'hAABBCCDD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;

            addr = 12'h004;
            din = 32'h0000008F;
            wEn = 2'b10;
            @(posedge clk);
            #1;
            wEn = 2'b00;

            addr = 12'h004;
            byteExt = 2'b01;
            #2;
            $display("Testcase 002: Byte Read Sign Extension (Negative)");
            #1;

            check_outputs(32'hFFFFFF8F);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            addr = 12'h004;
            byteExt = 2'b10;
            wEn = 2'b00;
            #2;
            $display("Testcase 003: Byte Read Zero Extension");
            #1;

            check_outputs(32'h0000008F);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            addr = 12'h008;
            din = 32'h11223344;
            wEn = 2'b10;
            @(posedge clk);
            #1;
            wEn = 2'b00;

            addr = 12'h009;
            byteExt = 2'b01;
            #2;
            $display("Testcase 004: Byte Read Sign Extension (Positive)");
            #1;

            check_outputs(32'h00000033);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            addr = 12'h00C;
            din = 32'h00000000;
            wEn = 2'b10;
            @(posedge clk);
            #1;

            addr = 12'h00E;
            din = 32'h00EE0000;
            wEn = 2'b01;
            @(posedge clk);
            #1;
            wEn = 2'b00;

            addr = 12'h00C;
            byteExt = 2'b00;
            #2;
            $display("Testcase 005: Byte Write Operation");
            #1;

            check_outputs(32'h00EE0000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            addr = 12'hFFC;
            din = 32'h55AA55AA;
            wEn = 2'b10;
            @(posedge clk);
            #1;
            wEn = 2'b00;
            byteExt = 2'b00;
            #2;
            $display("Testcase 006: Boundary Address Test");
            #1;

            check_outputs(32'h55AA55AA);
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
        input [31:0] expected_dout;
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
        $dumpvars(0,addr, byteExt, clk, din, wEn, dout);
    end

endmodule
