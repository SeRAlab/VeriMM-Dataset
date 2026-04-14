`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] A;
    reg Clk;
    reg [31:0] WD;
    reg WE;
    wire [31:0] RD;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .Clk(Clk),
        .WD(WD),
        .WE(WE),
        .RD(RD)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            A = 32'h0;
            WD = 32'h0;
            WE = 0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Value Check (Address 0)", test_num);
            reset_dut();
            A = 32'h0;
            WE = 0;
            #10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Initial Value Check (Address 508)", test_num);
            reset_dut();
            A = 32'd508;
            WE = 0;
            #10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write and Read (Address 4)", test_num);
            reset_dut();
            A = 32'd4;
            WD = 32'hDEADBEEF;
            WE = 1;
            @(posedge Clk);
            #1;
            WE = 0;
            #5;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write and Read (Address 508)", test_num);
            reset_dut();
            A = 32'd508;
            WD = 32'hCAFEBABE;
            WE = 1;
            @(posedge Clk);
            #1;
            WE = 0;
            #5;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Write Enable Check (WE=0)", test_num);
            reset_dut();
            A = 32'd8;
            WD = 32'hFFFFFFFF;
            WE = 0;
            @(posedge Clk);
            #1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Out of Range Check (Address 512)", test_num);
            reset_dut();
            A = 32'd512;
            WE = 0;
            #10;
            #1;

            check_outputs(32'hzzzzzzzz);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Out of Range Check (Address 0xFFFF0000)", test_num);
            reset_dut();
            A = 32'hFFFF0000;
            WE = 0;
            #10;
            #1;

            check_outputs(32'hzzzzzzzz);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Persistence Check", test_num);
            reset_dut();

            A = 32'd0; WD = 32'h11112222; WE = 1;
            @(posedge Clk);
            #1;

            A = 32'd4; WD = 32'h33334444; WE = 1;
            @(posedge Clk);
            #1;

            A = 32'd0; WE = 0;
            #5;
            #1;

            check_outputs(32'h11112222);
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
        testcase008();
        
        
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
        input [31:0] expected_RD;
        begin
            if (expected_RD === (expected_RD ^ RD ^ expected_RD)) begin
                $display("PASS");
                $display("  Outputs: RD=%h",
                         RD);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RD=%h",
                         expected_RD);
                $display("  Got:      RD=%h",
                         RD);
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
        $dumpvars(0,A, Clk, WD, WE, RD);
    end

endmodule
