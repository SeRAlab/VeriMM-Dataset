`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] I;
    reg clk;
    wire [2:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I(I),
        .clk(clk),
        .O(O)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            I <= 8'b0;
            repeat(4) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            I <= 8'b1000_0000;
            repeat(4) @(posedge clk);
            $display("Test %0d: Input Bit 7 (0x80)", test_num);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            I <= 8'b0000_0001;
            repeat(4) @(posedge clk);
            $display("Test %0d: Input Bit 0 (0x01)", test_num);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            I <= 8'b1000_0001;
            repeat(4) @(posedge clk);
            $display("Test %0d: Input Bits 7 and 0 (0x81)", test_num);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            I <= 8'b0001_0000;
            repeat(4) @(posedge clk);
            $display("Test %0d: Input Bit 4 (0x10)", test_num);
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            I <= 8'b0001_1110;
            repeat(4) @(posedge clk);
            $display("Test %0d: Input Bits 4,3,2,1 (0x1E)", test_num);
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            I <= 8'b0100_0000;
            repeat(4) @(posedge clk);
            $display("Test %0d: Input Bit 6 (0x40)", test_num);
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            I <= 8'b0000_1000;
            repeat(4) @(posedge clk);
            $display("Test %0d: Input Bit 3 (0x08)", test_num);
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            I <= 8'b0000_0010;
            repeat(4) @(posedge clk);
            $display("Test %0d: Input Bit 1 (0x02)", test_num);
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            I <= 8'b1111_1111;
            repeat(4) @(posedge clk);
            $display("Test %0d: All bits active (0xFF)", test_num);
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            reset_dut();
            I <= 8'b0101_0101;
            repeat(4) @(posedge clk);
            $display("Test %0d: Alternating bits (0x55)", test_num);
            #1;

            check_outputs(3'd6);
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
        testcase009();
        testcase010();
        
        
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
        input [2:0] expected_O;
        begin
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
                         O);
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
        $dumpvars(0,I, clk, O);
    end

endmodule
