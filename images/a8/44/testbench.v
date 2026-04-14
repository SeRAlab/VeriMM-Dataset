`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg e_tx_access;
    reg [3:0] e_tx_ctrlmode;
    reg [31:0] e_tx_data;
    reg [1:0] e_tx_datamode;
    reg [31:0] e_tx_dstaddr;
    reg [31:0] e_tx_srcaddr;
    reg e_tx_write;
    reg reset;
    wire e_tx_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .e_tx_access(e_tx_access),
        .e_tx_ctrlmode(e_tx_ctrlmode),
        .e_tx_data(e_tx_data),
        .e_tx_datamode(e_tx_datamode),
        .e_tx_dstaddr(e_tx_dstaddr),
        .e_tx_srcaddr(e_tx_srcaddr),
        .e_tx_write(e_tx_write),
        .reset(reset),
        .e_tx_done(e_tx_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            e_tx_access = 0;
            e_tx_write = 0;
            e_tx_datamode = 0;
            e_tx_ctrlmode = 0;
            e_tx_dstaddr = 0;
            e_tx_srcaddr = 0;
            e_tx_data = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write Operation", test_num);
            reset_dut();

            @(posedge clk);
            e_tx_access = 1;
            e_tx_write = 1;
            e_tx_datamode = 2'b01;
            e_tx_ctrlmode = 4'hA;
            e_tx_dstaddr = 32'hDEADBEEF;
            e_tx_srcaddr = 32'h12345678;
            e_tx_data = 32'hAAAA5555;

            @(posedge clk);
            e_tx_access = 0;


            @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Access without Write", test_num);
            reset_dut();

            @(posedge clk);
            e_tx_access = 1;
            e_tx_write = 0;
            e_tx_datamode = 2'b11;
            e_tx_ctrlmode = 4'h5;
            e_tx_dstaddr = 32'hCAFEBABE;
            e_tx_srcaddr = 32'h87654321;
            e_tx_data = 32'h0;

            @(posedge clk);
            e_tx_access = 0;

            @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: No Access Signal", test_num);
            reset_dut();

            @(posedge clk);
            e_tx_access = 0;
            e_tx_write = 1;
            e_tx_dstaddr = 32'h11112222;
            e_tx_data = 32'h33334444;

            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Reset Override during operation", test_num);
            reset_dut();

            @(posedge clk);
            e_tx_access = 1;
            e_tx_write = 1;

            @(posedge clk);
            reset = 1;

            @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Different Mode Write", test_num);
            reset_dut();

            @(posedge clk);
            e_tx_access = 1;
            e_tx_write = 1;
            e_tx_datamode = 2'b10;
            e_tx_ctrlmode = 4'hF;
            e_tx_dstaddr = 32'hFFFFFFFF;
            e_tx_srcaddr = 32'h00000000;
            e_tx_data = 32'h1234ABCD;

            @(posedge clk);
            e_tx_access = 0;

            @(posedge clk);
            #1;

            check_outputs(1'b1);
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
        input expected_e_tx_done;
        begin
            if (expected_e_tx_done === (expected_e_tx_done ^ e_tx_done ^ expected_e_tx_done)) begin
                $display("PASS");
                $display("  Outputs: e_tx_done=%b",
                         e_tx_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: e_tx_done=%b",
                         expected_e_tx_done);
                $display("  Got:      e_tx_done=%b",
                         e_tx_done);
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
        $dumpvars(0,clk, e_tx_access, e_tx_ctrlmode, e_tx_data, e_tx_datamode, e_tx_dstaddr, e_tx_srcaddr, e_tx_write, reset, e_tx_done);
    end

endmodule
