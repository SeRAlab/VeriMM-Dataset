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

        task reset_dut;

        begin
            WCLK = 0;
            WE = 0;
            D = 0;
            set_write_addr(4'b0000);
            set_dpra_addr(4'b0000);
            #25;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Write 1 to Address 0 and Read", test_num);


            WE = 1;
            D = 1;
            set_write_addr(4'd0);
            set_dpra_addr(4'd0);

            @(posedge WCLK);
            #5;
            WE = 0;

            #10;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Dual Port Access (Write @15, Read @15 and @0)", test_num);


            WE = 1; D = 0; set_write_addr(4'd0);
            @(posedge WCLK); #5;


            WE = 1; D = 1; set_write_addr(4'd15);
            @(posedge WCLK); #5;
            WE = 0;


            set_write_addr(4'd15);
            set_dpra_addr(4'd0);

            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Overwrite and WE check", test_num);


            WE = 1; D = 1; set_write_addr(4'd5);
            @(posedge WCLK); #5;


            WE = 0; D = 0; set_write_addr(4'd5);
            @(posedge WCLK); #5;

            set_write_addr(4'd5);
            set_dpra_addr(4'd5);
            #10;
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Immediate Read After Write", test_num);


            WE = 1; D = 1; set_write_addr(4'd8);
            set_dpra_addr(4'd8);
            @(posedge WCLK);
            #2;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Check address decoding (Address 4 vs 12)", test_num);


            WE = 1; D = 1; set_write_addr(4'b0100);
            @(posedge WCLK); #5;


            WE = 1; D = 0; set_write_addr(4'b1100);
            @(posedge WCLK); #5;
            WE = 0;


            set_write_addr(4'b0100);
            set_dpra_addr(4'b1100);
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
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
