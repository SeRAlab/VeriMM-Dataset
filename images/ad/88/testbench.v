`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] DATA_IN;
    reg EN;
    reg LOAD;
    reg RST;
    wire [3:0] DATA_OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .EN(EN),
        .LOAD(LOAD),
        .RST(RST),
        .DATA_OUT(DATA_OUT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        @(negedge CLK);
        RST = 1;
        LOAD = 0;
        EN = 0;
        DATA_IN = 4'b0000;
        @(posedge CLK);
        #2;
        RST = 0;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic Reset", test_num);
        reset_dut();
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load Data", test_num);
        reset_dut();
        @(negedge CLK);
        LOAD = 1;
        DATA_IN = 4'hA;
        @(posedge CLK);
        #2;
        LOAD = 0;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Increment by 3", test_num);
        reset_dut();
        @(negedge CLK);
        EN = 1;
        repeat(3) @(posedge CLK);
        #2;
        EN = 0;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Wrap around check", test_num);
        reset_dut();
        @(negedge CLK);
        LOAD = 1;
        DATA_IN = 4'hF;
        @(posedge CLK);
        #2;
        LOAD = 0;
        EN = 1;
        @(posedge CLK);
        #2;
        EN = 0;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable Hold", test_num);
        reset_dut();
        @(negedge CLK);
        EN = 1;
        repeat(5) @(posedge CLK);
        #2;
        EN = 0;
        repeat(3) @(posedge CLK);
        #2;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Reset Priority", test_num);
        reset_dut();
        @(negedge CLK);
        LOAD = 1;
        EN = 1;
        RST = 1;
        DATA_IN = 4'h5;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Load Priority", test_num);
        reset_dut();
        @(negedge CLK);
        LOAD = 1;
        EN = 1;
        DATA_IN = 4'hC;
        @(posedge CLK);
        #2;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Complex sequence", test_num);
        reset_dut();

        @(negedge CLK);
        LOAD = 1; DATA_IN = 4'h7;
        @(posedge CLK);
        #2;

        LOAD = 0; EN = 1;
        repeat(2) @(posedge CLK);
        #2;

        EN = 0;
        @(posedge CLK);
        #2;

        EN = 1;
        @(posedge CLK);
        #2;
        EN = 0;
        #1;

        check_outputs(4'hA);
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
        input [3:0] expected_DATA_OUT;
        begin
            if (expected_DATA_OUT === (expected_DATA_OUT ^ DATA_OUT ^ expected_DATA_OUT)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT=%h",
                         DATA_OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT=%h",
                         expected_DATA_OUT);
                $display("  Got:      DATA_OUT=%h",
                         DATA_OUT);
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
        $dumpvars(0,CLK, DATA_IN, EN, LOAD, RST, DATA_OUT);
    end

endmodule
