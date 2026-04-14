`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] dw;
    reg [5:0] r0;
    reg [5:0] r1;
    reg [5:0] rw;
    reg we;
    wire [31:0] d0;
    wire [31:0] d1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .dw(dw),
        .r0(r0),
        .r1(r1),
        .rw(rw),
        .we(we),
        .d0(d0),
        .d1(d1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            rw = 0;
            dw = 0;
            r0 = 0;
            r1 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %03d: Basic Write/Read...", test_num);


            @(posedge clk); #1;
            we = 1; rw = 10; dw = 32'hDEADBEEF;


            @(posedge clk); #1;
            we = 0; r0 = 10; r1 = 10;


            @(posedge clk); #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %03d: Dual Port Read...", test_num);


            @(posedge clk); #1;
            we = 1; rw = 5; dw = 32'h11112222;

            @(posedge clk); #1;
            we = 1; rw = 6; dw = 32'h33334444;


            @(posedge clk); #1;
            we = 0; r0 = 5; r1 = 6;

            @(posedge clk); #1;
            #1;

            check_outputs(32'h11112222, 32'h33334444);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %03d: Write Enable Check...", test_num);


            @(posedge clk); #1;
            we = 1; rw = 20; dw = 32'hAAAA_AAAA;
            @(posedge clk); #1;


            we = 0; rw = 20; dw = 32'hBBBB_BBBB;
            r0 = 20; r1 = 20;
            @(posedge clk); #1;


            @(posedge clk); #1;
            #1;

            check_outputs(32'hAAAA_AAAA, 32'hAAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %03d: Overwrite Register...", test_num);

            @(posedge clk); #1;
            we = 1; rw = 32; dw = 32'h12345678;
            @(posedge clk); #1;
            we = 1; rw = 32; dw = 32'h87654321;
            @(posedge clk); #1;
            we = 0; r0 = 32; r1 = 32;
            @(posedge clk); #1;
            #1;

            check_outputs(32'h87654321, 32'h87654321);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %03d: Boundary Addresses (0 and 63)...", test_num);

            @(posedge clk); #1;
            we = 1; rw = 0; dw = 32'h00000001;
            @(posedge clk); #1;
            we = 1; rw = 63; dw = 32'hFFFFFFFE;
            @(posedge clk); #1;
            we = 0; r0 = 0; r1 = 63;
            @(posedge clk); #1;
            #1;

            check_outputs(32'h00000001, 32'hFFFFFFFE);
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
        input [31:0] expected_d0;
        input [31:0] expected_d1;
        begin
            if (expected_d0 === (expected_d0 ^ d0 ^ expected_d0) &&
                expected_d1 === (expected_d1 ^ d1 ^ expected_d1)) begin
                $display("PASS");
                $display("  Outputs: d0=%h, d1=%h",
                         d0, d1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d0=%h, d1=%h",
                         expected_d0, expected_d1);
                $display("  Got:      d0=%h, d1=%h",
                         d0, d1);
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
        $dumpvars(0,clk, dw, r0, r1, rw, we, d0, d1);
    end

endmodule
