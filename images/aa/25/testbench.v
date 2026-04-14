`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] p1_a;
    reg [6:0] p2_a;
    reg [6:0] p3_a;
    reg [31:0] p3_d;
    reg p3_en;
    reg sys_clk;
    wire [31:0] p1_d;
    wire [31:0] p2_d;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p1_a(p1_a),
        .p2_a(p2_a),
        .p3_a(p3_a),
        .p3_d(p3_d),
        .p3_en(p3_en),
        .sys_clk(sys_clk),
        .p1_d(p1_d),
        .p2_d(p2_d)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            p1_a = 0;
            p2_a = 0;
            p3_a = 0;
            p3_d = 0;
            p3_en = 0;
            @(posedge sys_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Write and Dual Read...");
            reset_dut();

            @(posedge sys_clk);
            p3_en = 1;
            p3_a = 7'd15;
            p3_d = 32'hDEADBEEF;
            @(posedge sys_clk);
            p3_en = 0;


            p1_a = 7'd15;
            p2_a = 7'd15;
            @(posedge sys_clk);
            #2;
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Boundary Address Access...");
            reset_dut();

            @(posedge sys_clk);
            p3_en = 1; p3_a = 7'd0; p3_d = 32'h11112222;
            @(posedge sys_clk);

            p3_en = 1; p3_a = 7'd127; p3_d = 32'hAAAA5555;
            @(posedge sys_clk);
            p3_en = 0;


            p1_a = 7'd0;
            p2_a = 7'd127;
            @(posedge sys_clk);
            #2;
            #1;

            check_outputs(32'h11112222, 32'hAAAA5555);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Write Enable Verification...");
            reset_dut();

            @(posedge sys_clk);
            p3_en = 1; p3_a = 7'd50; p3_d = 32'h0000FFFF;
            @(posedge sys_clk);

            p3_en = 0; p3_a = 7'd50; p3_d = 32'hFFFF0000;
            @(posedge sys_clk);


            p1_a = 7'd50;
            p2_a = 7'd50;
            @(posedge sys_clk);
            #2;
            #1;

            check_outputs(32'h0000FFFF, 32'h0000FFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Data Overwrite and Port Independence...");
            reset_dut();

            @(posedge sys_clk);
            p3_en = 1; p3_a = 7'd20; p3_d = 32'h12345678;
            @(posedge sys_clk);

            p3_en = 1; p3_a = 7'd20; p3_d = 32'h87654321;
            @(posedge sys_clk);

            p3_en = 1; p3_a = 7'd21; p3_d = 32'hABCDEF01;
            @(posedge sys_clk);
            p3_en = 0;


            p1_a = 7'd20;
            p2_a = 7'd21;
            @(posedge sys_clk);
            #2;
            #1;

            check_outputs(32'h87654321, 32'hABCDEF01);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Simultaneous Reading...");
            reset_dut();

            @(posedge sys_clk);
            p3_en = 1; p3_a = 7'd100; p3_d = 32'h00C0FFEE;
            @(posedge sys_clk);
            p3_en = 1; p3_a = 7'd101; p3_d = 32'hBEEFCAFE;
            @(posedge sys_clk);
            p3_en = 0;


            p1_a = 7'd101;
            p2_a = 7'd100;
            @(posedge sys_clk);
            #2;
            #1;

            check_outputs(32'hBEEFCAFE, 32'h00C0FFEE);
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
        input [31:0] expected_p1_d;
        input [31:0] expected_p2_d;
        begin
            if (expected_p1_d === (expected_p1_d ^ p1_d ^ expected_p1_d) &&
                expected_p2_d === (expected_p2_d ^ p2_d ^ expected_p2_d)) begin
                $display("PASS");
                $display("  Outputs: p1_d=%h, p2_d=%h",
                         p1_d, p2_d);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p1_d=%h, p2_d=%h",
                         expected_p1_d, expected_p2_d);
                $display("  Got:      p1_d=%h, p2_d=%h",
                         p1_d, p2_d);
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
        $dumpvars(0,p1_a, p2_a, p3_a, p3_d, p3_en, sys_clk, p1_d, p2_d);
    end

endmodule
