`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] A;
    reg D;
    reg [6:0] DPRA;
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

    // Clock generation (10ns period)
    initial begin
        WCLK = 0;
        forever #5 WCLK = ~WCLK;
    end

        task reset_dut;

        begin
            A = 7'b0;
            D = 1'b0;
            DPRA = 7'b0;
            WE = 1'b0;
            @(posedge WCLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            A = 7'd10;
            DPRA = 7'd120;
            #2;
            $display("Test %0d: Initialization check (Addr 10 and 120)", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            A = 7'd42;
            D = 1'b1;
            WE = 1'b1;
            @(posedge WCLK);
            #1;
            WE = 1'b0;
            DPRA = 7'd42;
            #2;
            $display("Test %0d: Write 1 to address 42 and read back", test_num);
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            A = 7'd15;
            D = 1'b1;
            WE = 1'b0;
            @(posedge WCLK);
            #1;
            DPRA = 7'd15;
            #2;
            $display("Test %0d: WE=0 check - writing 1 to address 15", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            A = 7'd10; D = 1'b1; WE = 1'b1;
            @(posedge WCLK);
            #1;

            A = 7'd20; D = 1'b0; WE = 1'b1;
            @(posedge WCLK);
            #1;
            WE = 1'b0;
            A = 7'd10;
            DPRA = 7'd20;
            #2;
            $display("Test %0d: Dual port access (SPO=Addr 10, DPO=Addr 20)", test_num);
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            A = 7'd127; D = 1'b1; WE = 1'b1;
            @(posedge WCLK);
            #1;

            A = 7'd127; D = 1'b0; WE = 1'b1;
            @(posedge WCLK);
            #1;
            WE = 1'b0;
            DPRA = 7'd127;
            #2;
            $display("Test %0d: Boundary check (Addr 127) and overwrite logic", test_num);
            #1;

            check_outputs(1'b0, 1'b0);
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
