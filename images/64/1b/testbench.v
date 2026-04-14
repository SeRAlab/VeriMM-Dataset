`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg ld;
    reg [7:0] outbyte;
    wire sout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .ld(ld),
        .outbyte(outbyte),
        .sout(sout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ld = 1;
            outbyte = 8'h00;
            @(posedge clk);
            #1;
            ld = 0;
            outbyte = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            outbyte = 8'b10100101;
            ld = 1;
            @(posedge clk);
            #1;
            ld = 0;

            $display("Testcase %0d: Checking MSB after load (Expected: 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            outbyte = 8'b10100101;
            ld = 1;
            @(posedge clk);
            #1;
            ld = 0;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking bit 6 after 1 shift (Expected: 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            reset_dut();
            outbyte = 8'b10100101;
            ld = 1;
            @(posedge clk);
            #1;
            ld = 0;
            for (i = 0; i < 7; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            $display("Testcase %0d: Checking bit 0 after 7 shifts (Expected: 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            outbyte = 8'b01011010;
            ld = 1;
            @(posedge clk);
            #1;
            ld = 0;
            $display("Testcase %0d: Checking MSB of 0x5A after load (Expected: 0)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            outbyte = 8'hFF;
            ld = 1;
            @(posedge clk);
            #1;
            outbyte = 8'hAA;
            @(posedge clk);
            #1;
            $display("Testcase %0d: Checking sout after multiple load cycles (Expected: 1)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            reset_dut();
            outbyte = 8'b11110000;
            ld = 1;
            @(posedge clk);
            #1;
            ld = 0;
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
            end
            #1;
            $display("Testcase %0d: Checking bit 3 of 0xF0 after 4 shifts (Expected: 0)", test_num);
            #1;

            check_outputs(1'b0);
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
        input expected_sout;
        begin
            if (expected_sout === (expected_sout ^ sout ^ expected_sout)) begin
                $display("PASS");
                $display("  Outputs: sout=%b",
                         sout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sout=%b",
                         expected_sout);
                $display("  Got:      sout=%b",
                         sout);
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
        $dumpvars(0,clk, ld, outbyte, sout);
    end

endmodule
