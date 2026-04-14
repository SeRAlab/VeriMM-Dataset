`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] DATA_IN;
    reg EN;
    wire [31:0] DATA_OUT_1;
    wire [31:0] DATA_OUT_2;
    wire [31:0] DATA_OUT_3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA_IN(DATA_IN),
        .EN(EN),
        .DATA_OUT_1(DATA_OUT_1),
        .DATA_OUT_2(DATA_OUT_2),
        .DATA_OUT_3(DATA_OUT_3)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            EN = 1;
            DATA_IN = 32'h0;
            repeat(4) @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase 001: Basic Pipeline Propagation");
            reset_dut();

            @(negedge CLK);
            DATA_IN = 32'hAAAA_AAAA; EN = 1;
            @(negedge CLK);
            DATA_IN = 32'hBBBB_BBBB; EN = 1;
            @(negedge CLK);
            DATA_IN = 32'hCCCC_CCCC; EN = 1;
            @(negedge CLK);






            #1;







            check_outputs(32'hBBBB_BBBB, 32'hAAAA_AAAA, 32'hCCCC_CCCC);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase 002: Enable Control Check");
            reset_dut();

            @(negedge CLK);
            DATA_IN = 32'h1111_2222; EN = 1;
            @(negedge CLK);

            DATA_IN = 32'hDEAD_BEEF; EN = 0;
            repeat(3) @(negedge CLK);





            #1;






            check_outputs(32'h0000_0000, 32'h0000_0000, 32'hDEAD_BEEF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase 003: Timing and DATA_OUT_3 transparency");
            reset_dut();

            @(negedge CLK);
            DATA_IN = 32'h1; EN = 1; @(negedge CLK);
            DATA_IN = 32'h2; EN = 1; @(negedge CLK);
            DATA_IN = 32'h3; EN = 1; @(negedge CLK);



            #2;
            DATA_IN = 32'h9999_9999;
            #1;


            #1;



            check_outputs(32'h0000_0002, 32'h0000_0001, 32'h9999_9999);
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
        input [31:0] expected_DATA_OUT_1;
        input [31:0] expected_DATA_OUT_2;
        input [31:0] expected_DATA_OUT_3;
        begin
            if (expected_DATA_OUT_1 === (expected_DATA_OUT_1 ^ DATA_OUT_1 ^ expected_DATA_OUT_1) &&
                expected_DATA_OUT_2 === (expected_DATA_OUT_2 ^ DATA_OUT_2 ^ expected_DATA_OUT_2) &&
                expected_DATA_OUT_3 === (expected_DATA_OUT_3 ^ DATA_OUT_3 ^ expected_DATA_OUT_3)) begin
                $display("PASS");
                $display("  Outputs: DATA_OUT_1=%h, DATA_OUT_2=%h, DATA_OUT_3=%h",
                         DATA_OUT_1, DATA_OUT_2, DATA_OUT_3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DATA_OUT_1=%h, DATA_OUT_2=%h, DATA_OUT_3=%h",
                         expected_DATA_OUT_1, expected_DATA_OUT_2, expected_DATA_OUT_3);
                $display("  Got:      DATA_OUT_1=%h, DATA_OUT_2=%h, DATA_OUT_3=%h",
                         DATA_OUT_1, DATA_OUT_2, DATA_OUT_3);
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
        $dumpvars(0,CLK, DATA_IN, EN, DATA_OUT_1, DATA_OUT_2, DATA_OUT_3);
    end

endmodule
