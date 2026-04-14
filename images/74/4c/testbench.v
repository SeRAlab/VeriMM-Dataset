`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] Rd_Addr;
    reg [4:0] Rs_Addr;
    reg [4:0] Rt_Addr;
    reg [31:0] WriteData;
    reg WriteReg;
    reg clk;
    reg rst;
    wire [31:0] Rs;
    wire [31:0] Rt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Rd_Addr(Rd_Addr),
        .Rs_Addr(Rs_Addr),
        .Rt_Addr(Rt_Addr),
        .WriteData(WriteData),
        .WriteReg(WriteReg),
        .clk(clk),
        .rst(rst),
        .Rs(Rs),
        .Rt(Rt)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            WriteReg = 0;
            Rd_Addr = 0;
            WriteData = 0;
            Rs_Addr = 0;
            Rt_Addr = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset_dut();
            Rs_Addr = 5'd5;
            Rt_Addr = 5'd20;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Register 0 Hardwired Check", test_num);
            reset_dut();
            @(posedge clk);
            WriteReg = 1;
            Rd_Addr = 5'd0;
            WriteData = 32'hFFFF_FFFF;
            @(negedge clk);
            #1;
            WriteReg = 0;
            Rs_Addr = 5'd0;
            Rt_Addr = 5'd0;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write/Read", test_num);
            reset_dut();


            @(posedge clk);
            WriteReg = 1;
            Rd_Addr = 5'd1;
            WriteData = 32'h1234_5678;
            @(negedge clk);


            @(posedge clk);
            Rd_Addr = 5'd2;
            WriteData = 32'h8765_4321;
            @(negedge clk);

            WriteReg = 0;
            Rs_Addr = 5'd1;
            Rt_Addr = 5'd2;
            #1;
            #1;

            check_outputs(32'h1234_5678, 32'h8765_4321);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Check", test_num);
            reset_dut();

            @(posedge clk);
            WriteReg = 0;
            Rd_Addr = 5'd10;
            WriteData = 32'h55AA_55AA;
            @(negedge clk);

            Rs_Addr = 5'd10;
            Rt_Addr = 5'd10;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Register 31 Check", test_num);
            reset_dut();

            @(posedge clk);
            WriteReg = 1;
            Rd_Addr = 5'd31;
            WriteData = 32'hFFFF_FFFF;
            @(negedge clk);

            WriteReg = 0;
            Rs_Addr = 5'd31;
            Rt_Addr = 5'd31;
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dual Read Same Register", test_num);
            reset_dut();

            @(posedge clk);
            WriteReg = 1;
            Rd_Addr = 5'd15;
            WriteData = 32'hCAFE_BABE;
            @(negedge clk);

            Rs_Addr = 5'd15;
            Rt_Addr = 5'd15;
            #1;
            #1;

            check_outputs(32'hCAFE_BABE, 32'hCAFE_BABE);
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
        input [31:0] expected_Rs;
        input [31:0] expected_Rt;
        begin
            if (expected_Rs === (expected_Rs ^ Rs ^ expected_Rs) &&
                expected_Rt === (expected_Rt ^ Rt ^ expected_Rt)) begin
                $display("PASS");
                $display("  Outputs: Rs=%h, Rt=%h",
                         Rs, Rt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Rs=%h, Rt=%h",
                         expected_Rs, expected_Rt);
                $display("  Got:      Rs=%h, Rt=%h",
                         Rs, Rt);
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
        $dumpvars(0,Rd_Addr, Rs_Addr, Rt_Addr, WriteData, WriteReg, clk, rst, Rs, Rt);
    end

endmodule
