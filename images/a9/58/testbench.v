`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] D;
    reg [4:0] D_Addr;
    reg D_En;
    reg [4:0] S_Addr;
    reg [4:0] T_Addr;
    reg clk;
    reg reset;
    wire [31:0] S;
    wire [31:0] T;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .D_Addr(D_Addr),
        .D_En(D_En),
        .S_Addr(S_Addr),
        .T_Addr(T_Addr),
        .clk(clk),
        .reset(reset),
        .S(S),
        .T(T)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        D = 0;
        D_Addr = 0;
        D_En = 0;
        S_Addr = 0;
        T_Addr = 0;
        @(posedge clk);
        #2 reset = 0;
        @(posedge clk);
        #2;
    end
        endtask
    task testcase001;

    begin
        $display("testcase001: Checking if Register 0 is initialized to 0 after reset...");
        reset_dut();
        S_Addr = 0;
        T_Addr = 0;
        #2;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        $display("testcase002: Basic write to Reg[1] and read back...");
        reset_dut();
        D = 32'hDEADBEEF;
        D_Addr = 1;
        D_En = 1;
        @(posedge clk);
        #2;
        D_En = 0;
        S_Addr = 1;
        T_Addr = 0;
        #2;
        #1;

        check_outputs(32'hDEADBEEF, 32'h0);
    end
        endtask

    task testcase003;

    begin
        $display("testcase003: Attempting to write 0xFFFFFFFF to Reg[0]...");
        reset_dut();
        D = 32'hFFFFFFFF;
        D_Addr = 0;
        D_En = 1;
        @(posedge clk);
        #2;
        D_En = 0;
        S_Addr = 0;
        T_Addr = 0;
        #2;
        #1;

        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase004;

    begin
        $display("testcase004: Writing to Reg[10] and Reg[20], then dual reading...");
        reset_dut();

        D = 32'h12345678; D_Addr = 10; D_En = 1;
        @(posedge clk); #2;

        D = 32'h87654321; D_Addr = 20; D_En = 1;
        @(posedge clk); #2;
        D_En = 0;
        S_Addr = 10;
        T_Addr = 20;
        #2;
        #1;

        check_outputs(32'h12345678, 32'h87654321);
    end
        endtask

    task testcase005;

    begin
        $display("testcase005: Verify data is NOT written when D_En is 0...");
        reset_dut();

        D = 32'hAAAA_AAAA; D_Addr = 5; D_En = 1;
        @(posedge clk); #2;

        D = 32'hBBBB_BBBB; D_Addr = 5; D_En = 0;
        @(posedge clk); #2;
        S_Addr = 5;
        T_Addr = 0;
        #2;
        #1;

        check_outputs(32'hAAAA_AAAA, 32'h0);
    end
        endtask

    task testcase006;

    begin
        $display("testcase006: Writing to Reg[31] (Boundary Case)...");
        reset_dut();
        D = 32'h55AA_55AA;
        D_Addr = 31;
        D_En = 1;
        @(posedge clk); #2;
        D_En = 0;
        S_Addr = 31;
        T_Addr = 31;
        #2;
        #1;

        check_outputs(32'h55AA_55AA, 32'h55AA_55AA);
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
        input [31:0] expected_S;
        input [31:0] expected_T;
        begin
            if (expected_S === (expected_S ^ S ^ expected_S) &&
                expected_T === (expected_T ^ T ^ expected_T)) begin
                $display("PASS");
                $display("  Outputs: S=%h, T=%h",
                         S, T);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h, T=%h",
                         expected_S, expected_T);
                $display("  Got:      S=%h, T=%h",
                         S, T);
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
        $dumpvars(0,D, D_Addr, D_En, S_Addr, T_Addr, clk, reset, S, T);
    end

endmodule
