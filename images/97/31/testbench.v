`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg LOAD;
    reg [31:0] PAR_IN;
    reg SER_IN;
    wire SER_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .LOAD(LOAD),
        .PAR_IN(PAR_IN),
        .SER_IN(SER_IN),
        .SER_OUT(SER_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            LOAD = 1;
            PAR_IN = 32'h0;
            SER_IN = 0;
            @(posedge CLK);
            #1;
            LOAD = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTestcase %0d: Loading 0x80000000 - MSB should be 1", test_num);
            LOAD = 1;
            PAR_IN = 32'h8000_0000;
            @(posedge CLK);
            #1;
            LOAD = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTestcase %0d: Loading 0x7FFFFFFF - MSB should be 0", test_num);
            LOAD = 1;
            PAR_IN = 32'h7FFF_FFFF;
            @(posedge CLK);
            #1;
            LOAD = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTestcase %0d: Shift bit from index 30 to 31", test_num);
            LOAD = 1;
            PAR_IN = 32'h4000_0000;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SER_IN = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTestcase %0d: Shift bit from index 0 to 31 (31 shifts)", test_num);
            LOAD = 1;
            PAR_IN = 32'h0000_0001;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SER_IN = 0;
            repeat (31) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTestcase %0d: Propagate SER_IN through 32 cycles", test_num);
            LOAD = 0;
            SER_IN = 1;
            @(posedge CLK);
            SER_IN = 0;
            repeat (31) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("\nTestcase %0d: Propagate '0' through full register of '1's", test_num);
            LOAD = 1;
            PAR_IN = 32'hFFFF_FFFF;
            @(posedge CLK);
            #1;
            LOAD = 0;
            SER_IN = 0;
            repeat (32) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("\nTestcase %0d: Verify LOAD priority over Shift", test_num);
            LOAD = 1;
            PAR_IN = 32'hAAAAAAAA;
            @(posedge CLK);
            #1;

            SER_IN = 1;
            PAR_IN = 32'h5555_5555;
            @(posedge CLK);
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
        testcase006();
        testcase007();
        
        
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
        input expected_SER_OUT;
        begin
            if (expected_SER_OUT === (expected_SER_OUT ^ SER_OUT ^ expected_SER_OUT)) begin
                $display("PASS");
                $display("  Outputs: SER_OUT=%b",
                         SER_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SER_OUT=%b",
                         expected_SER_OUT);
                $display("  Got:      SER_OUT=%b",
                         SER_OUT);
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
        $dumpvars(0,CLK, LOAD, PAR_IN, SER_IN, SER_OUT);
    end

endmodule
