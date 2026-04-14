`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] Addr;
    reg Clk;
    wire [31:0] Instr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Addr(Addr),
        .Clk(Clk),
        .Instr(Instr)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Addr = 5'd0;
            @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reading Address 0x00", test_num);
            reset_dut();
            Addr = 5'h00;
            @(posedge Clk);
            #2;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reading Address 0x01", test_num);
            reset_dut();
            Addr = 5'h01;
            @(posedge Clk);
            #2;

            #1;


            check_outputs(32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reading Address 0x10", test_num);
            reset_dut();
            Addr = 5'h10;
            @(posedge Clk);
            #2;

            #1;


            check_outputs(32'h00000010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reading Maximum Address 0x1F", test_num);
            reset_dut();
            Addr = 5'h1F;
            @(posedge Clk);
            #2;

            #1;


            check_outputs(32'h0000001F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Access (Addr 5 then 6)", test_num);
            reset_dut();
            Addr = 5'h05;
            @(posedge Clk);
            #1;
            Addr = 5'h06;
            @(posedge Clk);
            #2;

            #1;


            check_outputs(32'h00000006);
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
        input [31:0] expected_Instr;
        begin
            if (expected_Instr === (expected_Instr ^ Instr ^ expected_Instr)) begin
                $display("PASS");
                $display("  Outputs: Instr=%h",
                         Instr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Instr=%h",
                         expected_Instr);
                $display("  Got:      Instr=%h",
                         Instr);
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
        $dumpvars(0,Addr, Clk, Instr);
    end

endmodule
