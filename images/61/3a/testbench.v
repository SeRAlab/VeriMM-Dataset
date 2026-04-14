`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] O_DAT;
    reg O_STB;
    reg RST;
    wire [7:0] COUNT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .O_DAT(O_DAT),
        .O_STB(O_STB),
        .RST(RST),
        .COUNT(COUNT)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            O_STB = 0;
            O_DAT = 32'h0;
            @(posedge CLK);
            #1 RST = 0;
            @(posedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge CLK);
            O_DAT = 32'hFFFFFFFF;
            O_STB = 0;
            repeat(2) @(posedge CLK);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge CLK);
            O_DAT = 32'hDEADBEEF;
            O_STB = 1;
            @(posedge CLK);
            O_STB = 0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(posedge CLK);
            O_STB = 1;
            O_DAT = 32'hA5A5A5A5; @(posedge CLK);
            O_DAT = 32'h5A5A5A5A; @(posedge CLK);
            O_DAT = 32'h12345678; @(posedge CLK);
            O_STB = 0;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(posedge CLK);
            O_STB = 1; O_DAT = 32'hEEEEEEEE; @(posedge CLK);
            O_STB = 0; O_DAT = 32'hFFFFFFFF; @(posedge CLK);
            O_STB = 1; O_DAT = 32'hDDDDDDDD; @(posedge CLK);
            O_STB = 0;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(posedge CLK);
            O_STB = 1; O_DAT = 32'hBAADF00D; @(posedge CLK);
            O_STB = 1; O_DAT = 32'hBAADF00D; @(posedge CLK);
            RST = 1; @(posedge CLK);
            RST = 0; @(posedge CLK);
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_COUNT;
        begin
            if (expected_COUNT === (expected_COUNT ^ COUNT ^ expected_COUNT)) begin
                $display("PASS");
                $display("  Outputs: COUNT=%h",
                         COUNT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUNT=%h",
                         expected_COUNT);
                $display("  Got:      COUNT=%h",
                         COUNT);
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
        $dumpvars(0,CLK, O_DAT, O_STB, RST, COUNT);
    end

endmodule
