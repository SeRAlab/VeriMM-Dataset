`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] Digit;
    reg clk;
    wire [7:0] Display;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Digit(Digit),
        .clk(clk),
        .Display(Display)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        Digit <= 4'hF;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        Digit <= 4'd0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h3F);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        Digit <= 4'd1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        Digit <= 4'd2;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h5B);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        Digit <= 4'd3;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h4F);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        Digit <= 4'd4;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h66);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        Digit <= 4'd5;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h6D);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = 7;
        Digit <= 4'd6;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h7D);
    end
        endtask

    task testcase008;

    begin
        reset_dut();
        test_num = 8;
        Digit <= 4'd7;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase009;

    begin
        reset_dut();
        test_num = 9;
        Digit <= 4'd8;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase010;

    begin
        reset_dut();
        test_num = 10;
        Digit <= 4'd9;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h6F);
    end
        endtask

    task testcase011;

    begin
        reset_dut();
        test_num = 11;
        Digit <= 4'd10;
        @(posedge clk);
        #1;
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        
        
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
        input [7:0] expected_Display;
        begin
            if (expected_Display === (expected_Display ^ Display ^ expected_Display)) begin
                $display("PASS");
                $display("  Outputs: Display=%h",
                         Display);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Display=%h",
                         expected_Display);
                $display("  Got:      Display=%h",
                         Display);
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
        $dumpvars(0,Digit, clk, Display);
    end

endmodule
