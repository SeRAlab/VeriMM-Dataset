`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg DOWN;
    reg LOAD;
    reg UP;
    reg [3:0] in;
    wire [3:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DOWN(DOWN),
        .LOAD(LOAD),
        .UP(UP),
        .in(in),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        LOAD = 1;
        in = 4'b0000;
        UP = 0;
        DOWN = 0;
        @(posedge CLK);
        #1;
        LOAD = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test %03d: Synchronous Load", test_num);
        reset_dut();
        LOAD = 1;
        in = 4'hA;
        @(posedge CLK);
        #1;
        LOAD = 0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %03d: Increment (UP)", test_num);
        reset_dut();
        UP = 1;
        DOWN = 0;
        LOAD = 0;
        @(posedge CLK);
        @(posedge CLK);
        @(posedge CLK);
        #1;
        UP = 0;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %03d: Decrement (DOWN)", test_num);
        reset_dut();

        LOAD = 1; in = 4'd5;
        @(posedge CLK);
        #1;
        LOAD = 0;

        DOWN = 1;
        UP = 0;
        @(posedge CLK);
        @(posedge CLK);
        #1;
        DOWN = 0;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %03d: Increment Wrap-around (15 to 0)", test_num);
        reset_dut();

        LOAD = 1; in = 4'hF;
        @(posedge CLK);
        #1;
        LOAD = 0;

        UP = 1;
        @(posedge CLK);
        #1;
        UP = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %03d: Decrement Wrap-around (0 to 15)", test_num);
        reset_dut();
        DOWN = 1;
        @(posedge CLK);
        #1;
        DOWN = 0;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %03d: LOAD Priority", test_num);
        reset_dut();
        LOAD = 1;
        in = 4'h7;
        UP = 1;
        DOWN = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        UP = 0;
        DOWN = 0;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %03d: No control signals", test_num);
        reset_dut();
        LOAD = 1; in = 4'hB;
        @(posedge CLK);
        #1;
        LOAD = 0;
        UP = 0;
        DOWN = 0;
        repeat(5) @(posedge CLK);
        #1;
        #1;

        check_outputs(4'hB);
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
        $dumpvars(0,CLK, DOWN, LOAD, UP, in, OUT);
    end

endmodule
