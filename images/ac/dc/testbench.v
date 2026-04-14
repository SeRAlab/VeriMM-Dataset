`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg L_S;
    reg [4:0] R_addr_A;
    reg [4:0] R_addr_B;
    reg [4:0] Wt_addr;
    reg [31:0] Wt_data;
    reg clk;
    reg rst;
    wire [31:0] rdata_A;
    wire [31:0] rdata_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .L_S(L_S),
        .R_addr_A(R_addr_A),
        .R_addr_B(R_addr_B),
        .Wt_addr(Wt_addr),
        .Wt_data(Wt_data),
        .clk(clk),
        .rst(rst),
        .rdata_A(rdata_A),
        .rdata_B(rdata_B)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            rst = 1;
            L_S = 0;
            Wt_addr = 0;
            Wt_data = 0;
            R_addr_A = 0;
            R_addr_B = 0;
            @(negedge clk);
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            R_addr_A = 5'd0;
            R_addr_B = 5'd5;
            #2;
            $display("Testcase %0d: Reset Check", test_num);
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            L_S = 1;
            Wt_addr = 5'd1;
            Wt_data = 32'hABCDE001;
            @(negedge clk);
            L_S = 0;
            R_addr_A = 5'd1;
            R_addr_B = 5'd0;
            #2;
            $display("Testcase %0d: Write R1 and Read back", test_num);
            #1;

            check_outputs(32'hABCDE001, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);
            L_S = 1;
            Wt_addr = 5'd0;
            Wt_data = 32'hFFFFFFFF;
            @(negedge clk);
            L_S = 0;
            R_addr_A = 5'd0;
            R_addr_B = 5'd0;
            #2;
            $display("Testcase %0d: Write R0 (Should remain 0)", test_num);
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            @(negedge clk);
            L_S = 1; Wt_addr = 5'd10; Wt_data = 32'h12345678;

            @(negedge clk);
            Wt_addr = 5'd20; Wt_data = 32'h87654321;
            @(negedge clk);
            L_S = 0;
            R_addr_A = 5'd10;
            R_addr_B = 5'd20;
            #2;
            $display("Testcase %0d: Dual Port Read R10 & R20", test_num);
            #1;

            check_outputs(32'h12345678, 32'h87654321);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            @(negedge clk);
            L_S = 0;
            Wt_addr = 5'd15;
            Wt_data = 32'h5555AAAA;
            @(negedge clk);
            R_addr_A = 5'd15;
            #2;
            $display("Testcase %0d: Write Enable (L_S=0) check", test_num);
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge clk);
            L_S = 1;
            Wt_addr = 5'd31;
            Wt_data = 32'hDEADBEEF;
            @(negedge clk);
            L_S = 0;
            R_addr_A = 5'd31;
            R_addr_B = 5'd31;
            #2;
            $display("Testcase %0d: Max Register (R31) check", test_num);
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
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
        input [31:0] expected_rdata_A;
        input [31:0] expected_rdata_B;
        begin
            if (expected_rdata_A === (expected_rdata_A ^ rdata_A ^ expected_rdata_A) &&
                expected_rdata_B === (expected_rdata_B ^ rdata_B ^ expected_rdata_B)) begin
                $display("PASS");
                $display("  Outputs: rdata_A=%h, rdata_B=%h",
                         rdata_A, rdata_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata_A=%h, rdata_B=%h",
                         expected_rdata_A, expected_rdata_B);
                $display("  Got:      rdata_A=%h, rdata_B=%h",
                         rdata_A, rdata_B);
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
        $dumpvars(0,L_S, R_addr_A, R_addr_B, Wt_addr, Wt_data, clk, rst, rdata_A, rdata_B);
    end

endmodule
