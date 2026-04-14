`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg [4:0] R_Addr_A;
    reg [4:0] R_Addr_B;
    reg [4:0] W_Addr;
    reg [31:0] W_Data;
    reg Write_Reg;
    reg reset;
    wire [31:0] R_Data_A;
    wire [31:0] R_Data_B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .R_Addr_A(R_Addr_A),
        .R_Addr_B(R_Addr_B),
        .W_Addr(W_Addr),
        .W_Data(W_Data),
        .Write_Reg(Write_Reg),
        .reset(reset),
        .R_Data_A(R_Data_A),
        .R_Data_B(R_Data_B)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            reset = 1;
            Write_Reg = 0;
            R_Addr_A = 0;
            R_Addr_B = 0;
            W_Addr = 0;
            W_Data = 0;
            @(posedge Clk);
            #1;
            reset = 0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();
            R_Addr_A = 5'd10;
            R_Addr_B = 5'd20;
            #2;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();
            @(negedge Clk);
            Write_Reg = 1;
            W_Addr = 5'd1;
            W_Data = 32'hDEADBEEF;
            @(negedge Clk);
            Write_Reg = 0;
            R_Addr_A = 5'd1;
            R_Addr_B = 5'd0;
            #2;
            #1;

            check_outputs(32'hDEADBEEF, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Register 0 Write Protection", test_num);
            reset_dut();
            @(negedge Clk);
            Write_Reg = 1;
            W_Addr = 5'd0;
            W_Data = 32'hFFFFFFFF;
            @(negedge Clk);
            Write_Reg = 0;
            R_Addr_A = 5'd0;
            R_Addr_B = 5'd0;
            #2;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dual Port Read", test_num);
            reset_dut();
            @(negedge Clk);
            Write_Reg = 1;
            W_Addr = 5'd15;
            W_Data = 32'h11112222;
            @(negedge Clk);
            W_Addr = 5'd25;
            W_Data = 32'h33334444;
            @(negedge Clk);
            Write_Reg = 0;
            R_Addr_A = 5'd15;
            R_Addr_B = 5'd25;
            #2;
            #1;

            check_outputs(32'h11112222, 32'h33334444);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Check", test_num);
            reset_dut();
            @(negedge Clk);
            Write_Reg = 0;
            W_Addr = 5'd5;
            W_Data = 32'hA5A5A5A5;
            @(negedge Clk);
            R_Addr_A = 5'd5;
            R_Addr_B = 5'd0;
            #2;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max Address Range", test_num);
            reset_dut();
            @(negedge Clk);
            Write_Reg = 1;
            W_Addr = 5'd31;
            W_Data = 32'h87654321;
            @(negedge Clk);
            Write_Reg = 0;
            R_Addr_A = 5'd31;
            R_Addr_B = 5'd31;
            #2;
            #1;

            check_outputs(32'h87654321, 32'h87654321);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Check", test_num);
            reset_dut();
            @(negedge Clk);
            Write_Reg = 1;
            W_Addr = 5'd7;
            W_Data = 32'h0000AAAA;
            @(negedge Clk);
            W_Data = 32'hBBBB0000;
            @(negedge Clk);
            Write_Reg = 0;
            R_Addr_A = 5'd7;
            R_Addr_B = 5'd0;
            #2;
            #1;

            check_outputs(32'hBBBB0000, 32'h0);
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
        testcase007();
        
        
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
        input [31:0] expected_R_Data_A;
        input [31:0] expected_R_Data_B;
        begin
            if (expected_R_Data_A === (expected_R_Data_A ^ R_Data_A ^ expected_R_Data_A) &&
                expected_R_Data_B === (expected_R_Data_B ^ R_Data_B ^ expected_R_Data_B)) begin
                $display("PASS");
                $display("  Outputs: R_Data_A=%h, R_Data_B=%h",
                         R_Data_A, R_Data_B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: R_Data_A=%h, R_Data_B=%h",
                         expected_R_Data_A, expected_R_Data_B);
                $display("  Got:      R_Data_A=%h, R_Data_B=%h",
                         R_Data_A, R_Data_B);
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
        $dumpvars(0,Clk, R_Addr_A, R_Addr_B, W_Addr, W_Data, Write_Reg, reset, R_Data_A, R_Data_B);
    end

endmodule
