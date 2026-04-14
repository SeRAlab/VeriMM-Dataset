`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg UP;
    wire [3:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RST(RST),
        .UP(UP),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        UP = 0;
        @(negedge CLK);
        RST = 0;
        @(negedge CLK);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();


        #1;



        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        UP = 1;
        repeat(5) @(negedge CLK);
        #1;

        check_outputs(4'd5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        UP = 1;
        repeat(16) @(negedge CLK);
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        UP = 0;
        repeat(1) @(negedge CLK);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        UP = 0;
        repeat(3) @(negedge CLK);
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        UP = 1;
        repeat(10) @(negedge CLK);
        UP = 0;
        repeat(4) @(negedge CLK);
        #1;

        check_outputs(4'd6);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        UP = 1;
        repeat(15) @(negedge CLK);
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        UP = 0;
        repeat(17) @(negedge CLK);
        #1;

        check_outputs(4'd15);
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
        testcase008();
        
        
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
        input [3:0] expected_OUT;
        begin
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
        $dumpvars(0,CLK, RST, UP, OUT);
    end

endmodule
