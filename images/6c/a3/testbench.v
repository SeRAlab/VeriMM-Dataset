`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] I;
    reg clk;
    wire EN;
    wire [2:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I(I),
        .clk(clk),
        .EN(EN),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            I = 8'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Bit 0 active", test_num);
            I = 8'b00000001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Bit 7 active", test_num);
            I = 8'b10000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'd7);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple bits (0 and 7) active", test_num);
            I = 8'b10000001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Multiple bits (3 and 5) active", test_num);
            I = 8'b00101000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'd3);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Memory check (hold previous Y)", test_num);

            I = 8'b00010000;
            @(posedge clk);
            #1;

            I = 8'b00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 3'd4);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: All bits active", test_num);
            I = 8'b11111111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Bit 5 active", test_num);
            I = 8'b00100000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 3'd5);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Memory check (hold Y=6)", test_num);
            I = 8'b01000000;
            @(posedge clk);
            #1;
            I = 8'b00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 3'd6);
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
        input expected_EN;
        input [2:0] expected_Y;
        begin
            if (expected_EN === (expected_EN ^ EN ^ expected_EN) &&
                expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: EN=%b, Y=%h",
                         EN, Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: EN=%b, Y=%h",
                         expected_EN, expected_Y);
                $display("  Got:      EN=%b, Y=%h",
                         EN, Y);
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
        $dumpvars(0,I, clk, EN, Y);
    end

endmodule
