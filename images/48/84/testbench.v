`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] RIGHT;
    reg [31:0] RIGHT_REG;
    reg RST;
    wire [31:0] LEFT_REG1;
    wire [31:0] RIGHT_REG1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RIGHT(RIGHT),
        .RIGHT_REG(RIGHT_REG),
        .RST(RST),
        .LEFT_REG1(LEFT_REG1),
        .RIGHT_REG1(RIGHT_REG1)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RST = 1;
        RIGHT = 0;
        RIGHT_REG = 0;
        @(posedge CLK);
        #1;
        RST = 0;
        @(posedge CLK);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Reset behavior check", test_num);
        reset_dut();

        #1;


        check_outputs(32'h0, 32'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Load basic values", test_num);
        reset_dut();
        RIGHT = 32'hAAAA_BBBB;
        RIGHT_REG = 32'hCCCC_DDDD;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(32'hAAAA_BBBB, 32'hCCCC_DDDD);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Continuous update check", test_num);
        reset_dut();


        RIGHT = 32'h1111_1111;
        RIGHT_REG = 32'h2222_2222;
        @(posedge CLK);


        RIGHT = 32'h3333_3333;
        RIGHT_REG = 32'h4444_4444;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(32'h3333_3333, 32'h4444_4444);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum value check (All Fs)", test_num);
        reset_dut();
        RIGHT = 32'hFFFF_FFFF;
        RIGHT_REG = 32'hFFFF_FFFF;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(32'hFFFF_FFFF, 32'hFFFF_FFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating bit pattern", test_num);
        reset_dut();
        RIGHT = 32'h5555_5555;
        RIGHT_REG = 32'hAAAA_AAAA;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(32'h5555_5555, 32'hAAAA_AAAA);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Asynchronous Reset Priority check", test_num);
        reset_dut();


        RIGHT = 32'h1234_5678;
        RIGHT_REG = 32'h8765_4321;


        RST = 1;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(32'h0, 32'h0);
        RST = 0;
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
        input [31:0] expected_LEFT_REG1;
        input [31:0] expected_RIGHT_REG1;
        begin
            if (expected_LEFT_REG1 === (expected_LEFT_REG1 ^ LEFT_REG1 ^ expected_LEFT_REG1) &&
                expected_RIGHT_REG1 === (expected_RIGHT_REG1 ^ RIGHT_REG1 ^ expected_RIGHT_REG1)) begin
                $display("PASS");
                $display("  Outputs: LEFT_REG1=%h, RIGHT_REG1=%h",
                         LEFT_REG1, RIGHT_REG1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEFT_REG1=%h, RIGHT_REG1=%h",
                         expected_LEFT_REG1, expected_RIGHT_REG1);
                $display("  Got:      LEFT_REG1=%h, RIGHT_REG1=%h",
                         LEFT_REG1, RIGHT_REG1);
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
        $dumpvars(0,CLK, RIGHT, RIGHT_REG, RST, LEFT_REG1, RIGHT_REG1);
    end

endmodule
