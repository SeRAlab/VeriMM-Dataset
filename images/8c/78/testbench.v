`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg A0;
    reg A1;
    reg A2;
    reg A3;
    reg D;
    reg DPRA0;
    reg DPRA1;
    reg DPRA2;
    reg DPRA3;
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
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .D(D),
        .DPRA0(DPRA0),
        .DPRA1(DPRA1),
        .DPRA2(DPRA2),
        .DPRA3(DPRA3),
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
            A0 = 0; A1 = 0; A2 = 0; A3 = 0;
            D = 0;
            DPRA0 = 0; DPRA1 = 0; DPRA2 = 0; DPRA3 = 0;
            WE = 0;
            @(posedge WCLK);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Dual Read", test_num);
            reset_dut();

            write_bit(4'h5, 1'b1);
            set_addresses(4'h5, 4'h5);

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Independent Port Reading", test_num);
            reset_dut();

            write_bit(4'h3, 1'b1);
            write_bit(4'h7, 1'b0);
            set_addresses(4'h3, 4'h7);

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Verification", test_num);
            reset_dut();

            @(negedge WCLK);
            A0 = 0; A1 = 1; A2 = 0; A3 = 1;
            D = 1;
            WE = 0;
            @(posedge WCLK);
            #2;

            set_addresses(4'hA, 4'hA);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Overwrite at Max Address", test_num);
            reset_dut();

            write_bit(4'hF, 1'b1);
            write_bit(4'hF, 1'b0);

            set_addresses(4'hF, 4'hF);
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Port Access", test_num);
            reset_dut();

            write_bit(4'h0, 1'b1);
            write_bit(4'h8, 1'b1);

            set_addresses(4'h0, 4'h8);
            #1;

            check_outputs(1'b1, 1'b1);
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
        $dumpvars(0,A0, A1, A2, A3, D, DPRA0, DPRA1, DPRA2, DPRA3, WCLK, WE, DPO, SPO);
    end

endmodule
