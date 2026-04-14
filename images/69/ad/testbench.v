`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] D0;
    reg [3:0] D1;
    reg [3:0] D2;
    reg [3:0] D3;
    reg LOAD;
    reg [1:0] SHIFT;
    wire [3:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .LOAD(LOAD),
        .SHIFT(SHIFT),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        D0 = 4'h0; D1 = 4'h0; D2 = 4'h0; D3 = 4'h0;
        LOAD = 1;
        SHIFT = 2'b00;
        @(posedge CLK);
        #1;
        LOAD = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Loading Data D3=A, D2=B, D1=C, D0=D", test_num);
        reset_dut();
        D3 = 4'hA; D2 = 4'hB; D1 = 4'hC; D0 = 4'hD;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;

        #1;


        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Left Shift (10) once", test_num);
        reset_dut();
        D3 = 4'h1; D2 = 4'h2; D1 = 4'h3; D0 = 4'h4;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        SHIFT = 2'b10;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(4'h2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Left Shift (11) once", test_num);
        reset_dut();
        D3 = 4'h5; D2 = 4'h6; D1 = 4'h7; D0 = 4'h8;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        SHIFT = 2'b11;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(4'h6);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Right Shift (01) once (Zero-fill check)", test_num);
        reset_dut();
        D3 = 4'hF; D2 = 4'hE; D1 = 4'hD; D0 = 4'hC;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        SHIFT = 2'b01;
        @(posedge CLK);
        #1;

        #1;


        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: No Shift (00) - Data persistence", test_num);
        reset_dut();
        D3 = 4'h9; D2 = 4'h8; D1 = 4'h7; D0 = 4'h6;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        SHIFT = 2'b00;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h9);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Triple Left Shift", test_num);
        reset_dut();
        D3 = 4'h1; D2 = 4'h2; D1 = 4'h3; D0 = 4'h4;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        SHIFT = 2'b10;
        repeat(3) @(posedge CLK);
        #1;

        #1;


        check_outputs(4'h4);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Shift Left 4 times (Register should be 0)", test_num);
        reset_dut();
        D3 = 4'hA; D2 = 4'hB; D1 = 4'hC; D0 = 4'hD;
        LOAD = 1;
        @(posedge CLK);
        #1;
        LOAD = 0;
        SHIFT = 2'b10;
        repeat(4) @(posedge CLK);
        #1;
        #1;

        check_outputs(4'h0);
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
        $dumpvars(0,CLK, D0, D1, D2, D3, LOAD, SHIFT, OUT);
    end

endmodule
