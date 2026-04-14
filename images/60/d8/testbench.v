`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rw;
    reg [7:0] uaddr;
    reg [7:0] udata_i;
    wire [7:0] udata_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rw(rw),
        .uaddr(uaddr),
        .udata_i(udata_i),
        .udata_o(udata_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rw = 0;
        uaddr = 0;
        udata_i = 0;

        repeat(2) @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Basic Write and Read...");
        reset_dut();


        uaddr = 8'h01;
        udata_i = 8'hA5;
        rw = 1;
        @(negedge clk);

        #5;

        rw = 0;
        uaddr = 8'h01;
        #10;

        #1;


        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Boundary Address 0xFF...");
        reset_dut();


        uaddr = 8'hFF;
        udata_i = 8'h5A;
        rw = 1;
        @(negedge clk);

        #5;

        rw = 0;
        uaddr = 8'hFF;
        #10;

        #1;


        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Overwriting existing data...");
        reset_dut();


        uaddr = 8'h10;
        udata_i = 8'h11;
        rw = 1;
        @(negedge clk);

        #10;

        udata_i = 8'h22;
        @(negedge clk);

        #5;

        rw = 0;
        uaddr = 8'h10;
        #10;

        #1;


        check_outputs(8'h22);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: High-Impedance Check (rw=1)...");
        reset_dut();


        uaddr = 8'h20;
        udata_i = 8'hCC;
        rw = 1;
        #5;

        #1;


        check_outputs(8'hzz);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Multiple Sequential Writes...");
        reset_dut();


        uaddr = 8'h05; udata_i = 8'h01; rw = 1;
        @(negedge clk);


        #5;
        uaddr = 8'h06; udata_i = 8'h02; rw = 1;
        @(negedge clk);

        #5;

        rw = 0;
        uaddr = 8'h05;
        #10;

        #1;


        check_outputs(8'h01);
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
        input [7:0] expected_udata_o;
        begin
            if (expected_udata_o === (expected_udata_o ^ udata_o ^ expected_udata_o)) begin
                $display("PASS");
                $display("  Outputs: udata_o=%h",
                         udata_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: udata_o=%h",
                         expected_udata_o);
                $display("  Got:      udata_o=%h",
                         udata_o);
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
        $dumpvars(0,clk, rw, uaddr, udata_i, udata_o);
    end

endmodule
