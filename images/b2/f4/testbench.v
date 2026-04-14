`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [63:0] probe0;
    reg [63:0] probe1;
    reg probe2;
    reg probe3;
    reg probe4;
    reg [3:0] probe5;
    wire [63:0] out_probe0;
    wire out_probe2;
    wire [3:0] out_probe3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .probe0(probe0),
        .probe1(probe1),
        .probe2(probe2),
        .probe3(probe3),
        .probe4(probe4),
        .probe5(probe5),
        .out_probe0(out_probe0),
        .out_probe2(out_probe2),
        .out_probe3(out_probe3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            probe0 = 64'd0;
            probe1 = 64'd0;
            probe2 = 1'b0;
            probe3 = 1'b0;
            probe4 = 1'b0;
            probe5 = 4'd0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Addition");
            reset_dut();
            probe0 = 64'h0000_0000_0000_0005;
            probe1 = 64'h0000_0000_0000_000A;
            probe2 = 1'b0;
            probe3 = 1'b1;
            probe4 = 1'b0;
            probe5 = 4'h3;

            @(posedge clk);
            #2;


            #1;



            check_outputs(64'h0000_0000_0000_000F, 1'b1, 4'h3);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Overflow Checks");
            reset_dut();

            probe0 = 64'hFFFF_FFFF_FFFF_FFFF;
            probe1 = 64'h0000_0000_0000_0001;

            probe2 = 1'b1;
            probe3 = 1'b1;

            probe4 = 1'b1;
            probe5 = 4'hF;

            @(posedge clk);
            #2;

            #1;


            check_outputs(64'h0000_0000_0000_0000, 1'b0, 4'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Large Hexadecimal Values");
            reset_dut();
            probe0 = 64'hAAAA_BBBB_CCCC_DDDD;
            probe1 = 64'h1111_1111_1111_1111;
            probe2 = 1'b1;
            probe3 = 1'b0;
            probe4 = 1'b1;
            probe5 = 4'h9;

            @(posedge clk);
            #2;

            #1;


            check_outputs(64'hBBBB_CCCC_DDDD_EEEE, 1'b1, 4'hA);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: All Zeros");
            reset_dut();
            probe0 = 64'd0;
            probe1 = 64'd0;
            probe2 = 1'b0;
            probe3 = 1'b0;
            probe4 = 1'b0;
            probe5 = 4'd0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(64'h0, 1'b0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Middle-range Values");
            reset_dut();
            probe0 = 64'h5555_5555_5555_5555;
            probe1 = 64'h2222_2222_2222_2222;
            probe2 = 1'b0;
            probe3 = 1'b0;
            probe4 = 1'b1;
            probe5 = 4'h7;

            @(posedge clk);
            #2;

            #1;


            check_outputs(64'h7777_7777_7777_7777, 1'b0, 4'h8);
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
        input [63:0] expected_out_probe0;
        input expected_out_probe2;
        input [3:0] expected_out_probe3;
        begin
            if (expected_out_probe0 === (expected_out_probe0 ^ out_probe0 ^ expected_out_probe0) &&
                expected_out_probe2 === (expected_out_probe2 ^ out_probe2 ^ expected_out_probe2) &&
                expected_out_probe3 === (expected_out_probe3 ^ out_probe3 ^ expected_out_probe3)) begin
                $display("PASS");
                $display("  Outputs: out_probe0=%h, out_probe2=%b, out_probe3=%h",
                         out_probe0, out_probe2, out_probe3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_probe0=%h, out_probe2=%b, out_probe3=%h",
                         expected_out_probe0, expected_out_probe2, expected_out_probe3);
                $display("  Got:      out_probe0=%h, out_probe2=%b, out_probe3=%h",
                         out_probe0, out_probe2, out_probe3);
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
        $dumpvars(0,clk, probe0, probe1, probe2, probe3, probe4, probe5, out_probe0, out_probe2, out_probe3);
    end

endmodule
