`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [31:0] dataw;
    reg memrw;
    wire [31:0] datar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .dataw(dataw),
        .memrw(memrw),
        .datar(datar)
    );

        task reset_dut;

        begin
            clk = 0;
            addr = 0;
            dataw = 0;
            memrw = 1;
            #20;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            addr = 8'h10;
            dataw = 32'hDEADBEEF;
            memrw = 0;
            @(posedge clk);
            #2;
            memrw = 1;
            #100;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            addr = 8'hFF;
            dataw = 32'h12345678;
            memrw = 0;
            @(posedge clk);
            #2;
            memrw = 1;
            #100;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            addr = 8'h20;
            dataw = 32'hAAAA_AAAA;
            memrw = 0;
            @(posedge clk);
            #10;

            dataw = 32'h5555_5555;
            memrw = 0;
            @(posedge clk);
            #2;
            memrw = 1;
            #100;
            #1;

            check_outputs(32'h5555_5555);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            addr = 8'h30;
            dataw = 32'hBBBB_BBBB;
            memrw = 0;
            @(posedge clk);
            #10;

            dataw = 32'hFFFF_FFFF;
            memrw = 1;
            @(posedge clk);
            #100;

            #1;


            check_outputs(32'hBBBB_BBBB);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            addr = 8'h00;
            dataw = 32'h0000_1111;
            memrw = 0;
            @(posedge clk);
            #2;
            memrw = 1;
            #100;
            #1;

            check_outputs(32'h0000_1111);
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
        input [31:0] expected_datar;
        begin
            if (expected_datar === (expected_datar ^ datar ^ expected_datar)) begin
                $display("PASS");
                $display("  Outputs: datar=%h",
                         datar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: datar=%h",
                         expected_datar);
                $display("  Got:      datar=%h",
                         datar);
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
        $dumpvars(0,addr, clk, dataw, memrw, datar);
    end

endmodule
