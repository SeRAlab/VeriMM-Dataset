`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg D;
    reg [7:0] DPRA;
    reg WCLK;
    reg WE;
    wire DPO;
    wire SPO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .D(D),
        .DPRA(DPRA),
        .WCLK(WCLK),
        .WE(WE),
        .DPO(DPO),
        .SPO(SPO)
    );

        task reset_dut;

        begin
            WE = 0;
            A = 0;
            D = 0;
            DPRA = 0;
            #15;
        end
        endtask
    task write_mem;

        input [7:0] addr;
        input data;
        begin
            @(posedge WCLK);
            A = addr;
            D = data;
            WE = 1;
            @(posedge WCLK);
            #2;
            WE = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %0d: Write 1 to Addr 0", test_num);
            write_mem(8'h00, 1'b1);
            A = 8'h00;
            DPRA = 8'h00;
            #5;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase %0d: Write 0 to Addr 255", test_num);

            write_mem(8'hFF, 1'b1);
            write_mem(8'hFF, 1'b0);
            A = 8'hFF;
            DPRA = 8'hFF;
            #5;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase %0d: Dual Port Read (A=5, DPRA=10)", test_num);
            write_mem(8'h05, 1'b1);
            write_mem(8'h0A, 1'b0);
            A = 8'h05;
            DPRA = 8'h0A;
            #5;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase %0d: Write Enable (WE) check", test_num);

            @(posedge WCLK);
            A = 8'h20;
            D = 1'b1;
            WE = 0;
            @(posedge WCLK);
            #2;
            A = 8'h20;
            DPRA = 8'h20;
            #5;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase %0d: Cross reading", test_num);
            write_mem(8'hAA, 1'b1);
            write_mem(8'h55, 1'b0);
            A = 8'h55;
            DPRA = 8'hAA;
            #5;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_DPO;
        input expected_SPO;
        begin
            if (expected_DPO === (expected_DPO ^ DPO ^ expected_DPO) &&
                expected_SPO === (expected_SPO ^ SPO ^ expected_SPO)) begin
                $display("PASS");
                $display("  Outputs: DPO=%b, SPO=%b",
                         DPO, SPO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DPO=%b, SPO=%b",
                         expected_DPO, expected_SPO);
                $display("  Got:      DPO=%b, SPO=%b",
                         DPO, SPO);
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
        $dumpvars(0,A, D, DPRA, WCLK, WE, DPO, SPO);
    end

endmodule
