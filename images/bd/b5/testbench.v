`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [31:0] I_DAT;
    reg I_STB;
    reg RST;
    wire [31:0] O_DAT;
    wire O_STB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .I_DAT(I_DAT),
        .I_STB(I_STB),
        .RST(RST),
        .O_DAT(O_DAT),
        .O_STB(O_STB)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            I_DAT = 32'h0;
            I_STB = 1'b0;
            @(posedge CLK);
            #1;
            RST = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            I_DAT = {16'd10, 16'd20};
            I_STB = 1'b1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(32'd200, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            I_DAT = {16'hFFFF, 16'hFFFF};
            I_STB = 1'b1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(32'hFFFE0001, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            I_DAT = {16'd500, 16'd0};
            I_STB = 1'b1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(32'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            I_DAT = {16'd5, 16'd5};
            I_STB = 1'b0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(32'd25, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            I_DAT = {16'd12, 16'd12};
            I_STB = 1'b1;
            RST = 1'b1;
            @(posedge CLK);
            #2;

            if (O_STB === 1'b0) begin
                $display("PASS: O_STB deasserted during reset");
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL: O_STB asserted during reset");
                fail_count = fail_count + 1;
            end
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            I_DAT = {16'd101, 16'd103};
            I_STB = 1'b1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(32'd10403, 1'b1);
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
        input [31:0] expected_O_DAT;
        input expected_O_STB;
        begin
            if (expected_O_DAT === (expected_O_DAT ^ O_DAT ^ expected_O_DAT) &&
                expected_O_STB === (expected_O_STB ^ O_STB ^ expected_O_STB)) begin
                $display("PASS");
                $display("  Outputs: O_DAT=%h, O_STB=%b",
                         O_DAT, O_STB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O_DAT=%h, O_STB=%b",
                         expected_O_DAT, expected_O_STB);
                $display("  Got:      O_DAT=%h, O_STB=%b",
                         O_DAT, O_STB);
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
        $dumpvars(0,CLK, I_DAT, I_STB, RST, O_DAT, O_STB);
    end

endmodule
