`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [8:0] RADR;
    reg REN;
    reg [8:0] WADR;
    reg [35:0] WDAT;
    reg WEN;
    wire [35:0] RDAT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RADR(RADR),
        .REN(REN),
        .WADR(WADR),
        .WDAT(WDAT),
        .WEN(WEN),
        .RDAT(RDAT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RADR = 0;
            REN = 0;
            WADR = 0;
            WDAT = 0;
            WEN = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read (Address 0x010)", test_num);
            reset_dut();


            WADR = 9'h010;
            WDAT = 36'h123456789;
            WEN = 1;
            @(posedge CLK);
            #1;
            WEN = 0;


            RADR = 9'h010;
            REN = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(36'h123456789);
            REN = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max Boundary Address (Address 0x1FF)", test_num);
            reset_dut();


            WADR = 9'h1FF;
            WDAT = 36'hAAAAAAAAA;
            WEN = 1;
            @(posedge CLK);
            #1;
            WEN = 0;


            RADR = 9'h1FF;
            REN = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(36'hAAAAAAAAA);
            REN = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Min Boundary Address (Address 0x000)", test_num);
            reset_dut();


            WADR = 9'h000;
            WDAT = 36'h555555555;
            WEN = 1;
            @(posedge CLK);
            #1;
            WEN = 0;


            RADR = 9'h000;
            REN = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(36'h555555555);
            REN = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write Enable (WEN) Check", test_num);
            reset_dut();


            WADR = 9'h050;
            WDAT = 36'hBCBCBCBCB;
            WEN = 1;
            @(posedge CLK);
            #1;


            WADR = 9'h050;
            WDAT = 36'h000000000;
            WEN = 0;
            @(posedge CLK);
            #1;


            RADR = 9'h050;
            REN = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(36'hBCBCBCBCB);
            REN = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: 36-bit Data Integrity Check", test_num);
            reset_dut();


            WADR = 9'h0A5;
            WDAT = 36'hF_FFFF_FFFF;
            WEN = 1;
            @(posedge CLK);
            #1;
            WEN = 0;


            RADR = 9'h0A5;
            REN = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(36'hF_FFFF_FFFF);
            REN = 0;
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
        input [35:0] expected_RDAT;
        begin
            if (expected_RDAT === (expected_RDAT ^ RDAT ^ expected_RDAT)) begin
                $display("PASS");
                $display("  Outputs: RDAT=%h",
                         RDAT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RDAT=%h",
                         expected_RDAT);
                $display("  Got:      RDAT=%h",
                         RDAT);
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
        $dumpvars(0,CLK, RADR, REN, WADR, WDAT, WEN, RDAT);
    end

endmodule
