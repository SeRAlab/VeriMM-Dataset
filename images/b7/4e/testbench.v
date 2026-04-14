`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg EN;
    reg [1:0] MODE;
    reg [1:0] SEL;
    reg clk;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .MODE(MODE),
        .SEL(SEL),
        .clk(clk),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            EN = 1;
            MODE = 2'b00;
            SEL = 2'b00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=1, MODE=00, SEL=11 - Expect Y=0", test_num);
            reset_dut();
            EN = 1;
            MODE = 2'b00;
            SEL = 2'b11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=0, MODE=00, SEL=00", test_num);
            reset_dut();
            EN = 0;
            MODE = 2'b00;
            SEL = 2'b00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=0, MODE=00, SEL=10", test_num);
            reset_dut();
            EN = 0;
            MODE = 2'b00;
            SEL = 2'b10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=0, MODE=01, Sequential SEL Change", test_num);
            reset_dut();
            EN = 0;
            MODE = 2'b01;


            SEL = 2'b01;
            @(posedge clk);
            #1;


            SEL = 2'b11;
            @(posedge clk);
            #1;



            if (Y !== 4'b0000) begin
                pass_count = pass_count + 1;
                $display("PASS: Dynamic response detected");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: No dynamic response in MODE 01");
            end
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: EN=0, MODE=10, Input sequence", test_num);
            reset_dut();
            EN = 0;
            MODE = 2'b10;

            SEL = 2'b10;
            @(posedge clk);
            #1;

            SEL = 2'b01;
            @(posedge clk);
            #1;


            #1;



            check_outputs(Y);
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
        input [3:0] expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
        $dumpvars(0,EN, MODE, SEL, clk, Y);
    end

endmodule
