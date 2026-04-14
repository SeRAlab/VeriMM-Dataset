`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [7:0] IN;
    reg [2:0] INADDRESS;
    reg [2:0] OUT1ADDRESS;
    reg [2:0] OUT2ADDRESS;
    reg RESET;
    reg WRITE;
    wire [7:0] OUT1;
    wire [7:0] OUT2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .IN(IN),
        .INADDRESS(INADDRESS),
        .OUT1ADDRESS(OUT1ADDRESS),
        .OUT2ADDRESS(OUT2ADDRESS),
        .RESET(RESET),
        .WRITE(WRITE),
        .OUT1(OUT1),
        .OUT2(OUT2)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RESET = 1;
        WRITE = 0;
        IN = 8'h00;
        INADDRESS = 3'b000;
        OUT1ADDRESS = 3'b000;
        OUT2ADDRESS = 3'b000;
        @(posedge CLK);
        #1 RESET = 0;
        @(posedge CLK);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset Verification");
        reset_dut();

        OUT1ADDRESS = 3'd2;
        OUT2ADDRESS = 3'd7;
        #1;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Single Write and Read");
        reset_dut();


        @(posedge CLK);
        WRITE = 1;
        IN = 8'hAA;
        INADDRESS = 3'd3;
        @(posedge CLK);
        WRITE = 0;


        OUT1ADDRESS = 3'd3;
        OUT2ADDRESS = 3'd3;
        #1;
        #1;

        check_outputs(8'hAA, 8'hAA);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Multiple Writes and Dual Port Read");
        reset_dut();


        @(posedge CLK);
        WRITE = 1;
        IN = 8'h55;
        INADDRESS = 3'd1;
        @(posedge CLK);


        IN = 8'hCC;
        INADDRESS = 3'd4;
        @(posedge CLK);
        WRITE = 0;


        OUT1ADDRESS = 3'd1;
        OUT2ADDRESS = 3'd4;
        #1;
        #1;

        check_outputs(8'h55, 8'hCC);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Write Enable Check");
        reset_dut();


        @(posedge CLK);
        WRITE = 0;
        IN = 8'hFF;
        INADDRESS = 3'd5;
        @(posedge CLK);


        OUT1ADDRESS = 3'd5;
        OUT2ADDRESS = 3'd0;
        #1;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Overwriting Register Content");
        reset_dut();


        @(posedge CLK);
        WRITE = 1;
        IN = 8'h11;
        INADDRESS = 3'd6;
        @(posedge CLK);


        IN = 8'h22;
        INADDRESS = 3'd6;
        @(posedge CLK);
        WRITE = 0;

        OUT1ADDRESS = 3'd6;
        OUT2ADDRESS = 3'd0;
        #1;
        #1;

        check_outputs(8'h22, 8'h00);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: Boundary Registers (0 and 7)");
        reset_dut();


        @(posedge CLK);
        WRITE = 1;
        IN = 8'h01;
        INADDRESS = 3'd0;
        @(posedge CLK);


        IN = 8'h07;
        INADDRESS = 3'd7;
        @(posedge CLK);
        WRITE = 0;

        OUT1ADDRESS = 3'd0;
        OUT2ADDRESS = 3'd7;
        #1;
        #1;

        check_outputs(8'h01, 8'h07);
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
        input [7:0] expected_OUT1;
        input [7:0] expected_OUT2;
        begin
            if (expected_OUT1 === (expected_OUT1 ^ OUT1 ^ expected_OUT1) &&
                expected_OUT2 === (expected_OUT2 ^ OUT2 ^ expected_OUT2)) begin
                $display("PASS");
                $display("  Outputs: OUT1=%h, OUT2=%h",
                         OUT1, OUT2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT1=%h, OUT2=%h",
                         expected_OUT1, expected_OUT2);
                $display("  Got:      OUT1=%h, OUT2=%h",
                         OUT1, OUT2);
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
        $dumpvars(0,CLK, IN, INADDRESS, OUT1ADDRESS, OUT2ADDRESS, RESET, WRITE, OUT1, OUT2);
    end

endmodule
