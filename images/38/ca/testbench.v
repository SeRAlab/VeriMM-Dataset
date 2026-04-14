`timescale 1ns/1ps

module ecc_point_doubling_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] x1;
    reg [15:0] y1;
    wire [15:0] x3;
    wire [15:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ecc_point_doubling dut (
        .clk(clk),
        .reset(reset),
        .x1(x1),
        .y1(y1),
        .x3(x3),
        .y3(y3)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            x1 = 0;
            y1 = 0;
            repeat(2) @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input (1, 1)", test_num);
            reset_dut();
            x1 = 16'h0001;
            y1 = 16'h0001;

            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'h0002, 16'hFFFD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input (3, 14)", test_num);
            reset_dut();
            x1 = 16'h0003;
            y1 = 16'h000E;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'hFFFB, 16'hFFFA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input (5, 38)", test_num);
            reset_dut();
            x1 = 16'h0005;
            y1 = 16'h0026;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'hFFF7, 16'hFFE8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Input (1, 10)", test_num);
            reset_dut();
            x1 = 16'h0001;
            y1 = 16'h000A;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(16'hFFFE, 16'hFFF6);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ecc_point_doubling Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input [15:0] expected_x3;
        input [15:0] expected_y3;
        begin
            if (expected_x3 === (expected_x3 ^ x3 ^ expected_x3) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: x3=%h, y3=%h",
                         x3, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x3=%h, y3=%h",
                         expected_x3, expected_y3);
                $display("  Got:      x3=%h, y3=%h",
                         x3, y3);
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
        $dumpvars(0,clk, reset, x1, y1, x3, y3);
    end

endmodule
