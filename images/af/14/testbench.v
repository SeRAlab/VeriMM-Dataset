`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CS;
    reg SDI;
    wire SDO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .CS(CS),
        .SDI(SDI),
        .SDO(SDO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        CS = 1;
        SDI = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    integer i;
    begin
        test_num = 1;
        $display("Testcase %03d: Shifting in 0xFF (Max Resistance)", test_num);
        reset_dut();
        CS = 0;
        for (i = 0; i < 8; i = i + 1) begin
            SDI = 1;
            @(posedge CLK);
            #1;
        end
        CS = 1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    integer i;
    begin
        test_num = 2;
        $display("Testcase %03d: Shifting in 0x00 (Min Resistance)", test_num);
        reset_dut();
        CS = 0;
        for (i = 0; i < 8; i = i + 1) begin
            SDI = 0;
            @(posedge CLK);
            #1;
        end
        CS = 1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    integer i;
    begin
        test_num = 3;
        $display("Testcase %03d: Shifting in 0x80", test_num);
        reset_dut();
        CS = 0;

        SDI = 1; @(posedge CLK); #1;

        SDI = 0;
        for (i = 0; i < 7; i = i + 1) begin
            @(posedge CLK);
            #1;
        end
        CS = 1;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    integer i;
    begin
        test_num = 4;
        $display("Testcase %03d: Verifying CS Inactive (High) prevents update", test_num);
        reset_dut();

        CS = 0;
        for (i = 0; i < 8; i = i + 1) begin SDI = 0; @(posedge CLK); #1; end
        CS = 1;


        for (i = 0; i < 8; i = i + 1) begin
            SDI = 1;
            @(posedge CLK);
            #1;
        end

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        $display("Testcase %03d: Mid-shift CS De-assertion", test_num);
        reset_dut();
        CS = 0;

        for (i = 0; i < 4; i = i + 1) begin SDI = 1; @(posedge CLK); #1; end
        CS = 1;
        SDI = 0;
        repeat(4) @(posedge CLK);
        #1;

        #1;


        check_outputs(1'b0);
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
        input expected_SDO;
        begin
            if (expected_SDO === (expected_SDO ^ SDO ^ expected_SDO)) begin
                $display("PASS");
                $display("  Outputs: SDO=%b",
                         SDO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SDO=%b",
                         expected_SDO);
                $display("  Got:      SDO=%b",
                         SDO);
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
        $dumpvars(0,CLK, CS, SDI, SDO);
    end

endmodule
