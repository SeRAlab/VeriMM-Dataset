`timescale 1ns/1ps

module SISO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg SI;
    wire SO;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SISO_Shift_Register dut (
        .CLK(CLK),
        .RST(RST),
        .SI(SI),
        .SO(SO)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            SI = 0;
            @(posedge CLK);
            #1 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in 1, 0, 1, 1 - Expect SO=1 (after 4 cycles)", test_num);
            reset_dut();
            SI = 1; @(posedge CLK);
            SI = 0; @(posedge CLK);
            SI = 1; @(posedge CLK);
            SI = 1; @(posedge CLK);
            #1 #1;
 check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in 0, 1, 1, 0 - Expect SO=0 (after 4 cycles)", test_num);
            reset_dut();
            SI = 0; @(posedge CLK);
            SI = 1; @(posedge CLK);
            SI = 1; @(posedge CLK);
            SI = 0; @(posedge CLK);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in 5 bits (1,0,0,0,1) - Expect SO=0 (2nd bit)", test_num);
            reset_dut();
            SI = 1; @(posedge CLK);
            SI = 0; @(posedge CLK);
            SI = 0; @(posedge CLK);
            SI = 0; @(posedge CLK);
            SI = 1; @(posedge CLK);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift in 8 bits (11110000) - Expect SO=0 (5th bit)", test_num);
            reset_dut();

            SI = 1; @(posedge CLK);
            SI = 1; @(posedge CLK);
            SI = 1; @(posedge CLK);
            SI = 1; @(posedge CLK);

            SI = 0; @(posedge CLK);
            SI = 0; @(posedge CLK);
            SI = 0; @(posedge CLK);
            SI = 0; @(posedge CLK);
            #1 #1;
 check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset verification", test_num);
            reset_dut();

            SI = 1; @(posedge CLK);
            SI = 1; @(posedge CLK);
            SI = 1; @(posedge CLK);
            SI = 1; @(posedge CLK);

            RST = 1;
            @(posedge CLK);
            #1 RST = 0;

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
        $display("SISO_Shift_Register Testbench");
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
        input expected_SO;
        begin
            if (expected_SO === (expected_SO ^ SO ^ expected_SO)) begin
                $display("PASS");
                $display("  Outputs: SO=%b",
                         SO);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SO=%b",
                         expected_SO);
                $display("  Got:      SO=%b",
                         SO);
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
        $dumpvars(0,CLK, RST, SI, SO);
    end

endmodule
