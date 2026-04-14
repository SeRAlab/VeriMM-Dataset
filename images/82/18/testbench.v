`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] Data_in;
    reg RegWr;
    reg [4:0] Rs;
    reg [4:0] Rt;
    reg [4:0] Rw;
    reg clk;
    reg rst;
    wire [31:0] BusA;
    wire [31:0] BusB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Data_in(Data_in),
        .RegWr(RegWr),
        .Rs(Rs),
        .Rt(Rt),
        .Rw(Rw),
        .clk(clk),
        .rst(rst),
        .BusA(BusA),
        .BusB(BusB)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1'b1;
            RegWr = 1'b0;
            Rw = 5'd0;
            Data_in = 32'h0;
            Rs = 5'd0;
            Rt = 5'd0;
            @(negedge clk);
            rst = 1'b0;
            @(negedge clk);
            rst = 1'b1;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Verification", test_num);
            reset_dut();

            Rs = 5'd10;
            Rt = 5'd31;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write/Read (Reg 5)", test_num);
            reset_dut();
            @(negedge clk);
            RegWr = 1'b1;
            Rw = 5'd5;
            Data_in = 32'hABCD1234;
            @(negedge clk);
            RegWr = 1'b0;
            Rs = 5'd5;
            Rt = 5'd0;
            #1;
            #1;

            check_outputs(32'hABCD1234, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dual Bus Read (Reg 1 and Reg 2)", test_num);
            reset_dut();
            @(negedge clk);
            RegWr = 1'b1;
            Rw = 5'd1;
            Data_in = 32'h1111_1111;
            @(negedge clk);
            Rw = 5'd2;
            Data_in = 32'h2222_2222;
            @(negedge clk);
            RegWr = 1'b0;
            Rs = 5'd1;
            Rt = 5'd2;
            #1;
            #1;

            check_outputs(32'h1111_1111, 32'h2222_2222);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: RegWr Enable Signal Check", test_num);
            reset_dut();
            @(negedge clk);
            RegWr = 1'b0;
            Rw = 5'd15;
            Data_in = 32'hFFFF_FFFF;
            @(negedge clk);
            Rs = 5'd15;
            Rt = 5'd15;
            #1;

            #1;


            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Register Check (0 and 31)", test_num);
            reset_dut();
            @(negedge clk);
            RegWr = 1'b1;
            Rw = 5'd0;
            Data_in = 32'hCAFE_BABE;
            @(negedge clk);
            Rw = 5'd31;
            Data_in = 32'hDEAD_BEEF;
            @(negedge clk);
            RegWr = 1'b0;
            Rs = 5'd0;
            Rt = 5'd31;
            #1;
            #1;

            check_outputs(32'hCAFE_BABE, 32'hDEAD_BEEF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwriting Register Data", test_num);
            reset_dut();
            @(negedge clk);
            RegWr = 1'b1;
            Rw = 5'd7;
            Data_in = 32'h0000_AAAA;
            @(negedge clk);
            Data_in = 32'h5555_0000;
            @(negedge clk);
            RegWr = 1'b0;
            Rs = 5'd7;
            Rt = 5'd7;
            #1;
            #1;

            check_outputs(32'h5555_0000, 32'h5555_0000);
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
        input [31:0] expected_BusA;
        input [31:0] expected_BusB;
        begin
            if (expected_BusA === (expected_BusA ^ BusA ^ expected_BusA) &&
                expected_BusB === (expected_BusB ^ BusB ^ expected_BusB)) begin
                $display("PASS");
                $display("  Outputs: BusA=%h, BusB=%h",
                         BusA, BusB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: BusA=%h, BusB=%h",
                         expected_BusA, expected_BusB);
                $display("  Got:      BusA=%h, BusB=%h",
                         BusA, BusB);
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
        $dumpvars(0,Data_in, RegWr, Rs, Rt, Rw, clk, rst, BusA, BusB);
    end

endmodule
