`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg DI0;
    reg DI1;
    reg RAD0;
    reg RAD1;
    reg RAD2;
    reg RAD3;
    reg WAD0;
    reg WAD1;
    reg WAD2;
    reg WAD3;
    reg WCK;
    reg WRE;
    wire DO0;
    wire DO1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DI0(DI0),
        .DI1(DI1),
        .RAD0(RAD0),
        .RAD1(RAD1),
        .RAD2(RAD2),
        .RAD3(RAD3),
        .WAD0(WAD0),
        .WAD1(WAD1),
        .WAD2(WAD2),
        .WAD3(WAD3),
        .WCK(WCK),
        .WRE(WRE),
        .DO0(DO0),
        .DO1(DO1)
    );

        task reset_dut;

    begin
        DI0 = 0; DI1 = 0;
        RAD0 = 0; RAD1 = 0; RAD2 = 0; RAD3 = 0;
        WAD0 = 0; WAD1 = 0; WAD2 = 0; WAD3 = 0;
        WCK = 0;
        WRE = 0;
        #20;
    end
        endtask
    task set_wad;

        input [3:0] addr;
        begin
            WAD3 = addr[3]; WAD2 = addr[2]; WAD1 = addr[1]; WAD0 = addr[0];
        end
        endtask

    task set_rad;

        input [3:0] addr;
        begin
            RAD3 = addr[3]; RAD2 = addr[2]; RAD1 = addr[1]; RAD0 = addr[0];
        end
        endtask

    task set_di;

        input [1:0] data;
        begin
            DI1 = data[1]; DI0 = data[0];
        end
        endtask

    task pulse_wck;

        begin
            #5 WCK = 1;
            #5 WCK = 0;
            #5;
        end
        endtask

    task testcase001;

    begin
        $display("Test Case 001: Basic Write and Read (Addr 0, Data 2'b11)");
        reset_dut();
        set_wad(4'h0);
        set_di(2'b11);
        WRE = 1;
        pulse_wck();
        WRE = 0;

        set_rad(4'h0);
        #10;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Write and Read (Addr 10, Data 2'b10)");
        reset_dut();
        set_wad(4'hA);
        set_di(2'b10);
        WRE = 1;
        pulse_wck();
        WRE = 0;

        set_rad(4'hA);
        #10;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Write Enable logic check");
        reset_dut();

        set_wad(4'h5);
        set_di(2'b01);
        WRE = 1;
        pulse_wck();


        set_di(2'b11);
        WRE = 0;
        pulse_wck();


        set_rad(4'h5);
        #10;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Dual Port simultaneous access");
        reset_dut();

        set_wad(4'h2);
        set_di(2'b11);
        WRE = 1;
        pulse_wck();


        set_rad(4'h2);
        set_wad(4'h7);
        set_di(2'b00);
        WRE = 1;
        pulse_wck();

        #10;
        #1;

        check_outputs(1, 1);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Boundary address check (Addr 15)");
        reset_dut();
        set_wad(4'hF);
        set_di(2'b10);
        WRE = 1;
        pulse_wck();

        set_rad(4'hF);
        #10;
        #1;

        check_outputs(0, 1);
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
        input expected_DO0;
        input expected_DO1;
        begin
            if (expected_DO0 === (expected_DO0 ^ DO0 ^ expected_DO0) &&
                expected_DO1 === (expected_DO1 ^ DO1 ^ expected_DO1)) begin
                $display("PASS");
                $display("  Outputs: DO0=%b, DO1=%b",
                         DO0, DO1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DO0=%b, DO1=%b",
                         expected_DO0, expected_DO1);
                $display("  Got:      DO0=%b, DO1=%b",
                         DO0, DO1);
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
        $dumpvars(0,DI0, DI1, RAD0, RAD1, RAD2, RAD3, WAD0, WAD1, WAD2, WAD3, WCK, WRE, DO0, DO1);
    end

endmodule
