`timescale 1ns/1ps

module ECC_Point_Addition_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [15:0] x1;
    reg [15:0] x2;
    reg [15:0] y1;
    reg [15:0] y2;
    wire [15:0] x3;
    wire [15:0] y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ECC_Point_Addition dut (
        .clk(clk),
        .reset(reset),
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
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
        x2 = 0;
        y2 = 0;
        @(posedge clk);
        #2 reset = 0;
        repeat(2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Test Case %0d: Standard Addition (5,1) + (6,3)", test_num);
        x1 = 16'h5; y1 = 16'h1;
        x2 = 16'h6; y2 = 16'h3;

        repeat(20) @(posedge clk);
        #1;

        check_outputs(16'hA, 16'h6);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Test Case %0d: Point Doubling (5,1) + (5,1)", test_num);
        x1 = 16'h5; y1 = 16'h1;
        x2 = 16'h5; y2 = 16'h1;
        repeat(20) @(posedge clk);
        #1;

        check_outputs(16'h6, 16'h3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Test Case %0d: Identity Left (0,0) + (5,1)", test_num);
        x1 = 16'h0; y1 = 16'h0;
        x2 = 16'h5; y2 = 16'h1;
        repeat(20) @(posedge clk);
        #1;

        check_outputs(16'h5, 16'h1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Test Case %0d: Identity Right (6,3) + (0,0)", test_num);
        x1 = 16'h6; y1 = 16'h3;
        x2 = 16'h0; y2 = 16'h0;
        repeat(20) @(posedge clk);
        #1;

        check_outputs(16'h6, 16'h3);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Test Case %0d: Addition with Inverse (5,1) + (5,16)", test_num);
        x1 = 16'h5; y1 = 16'h1;
        x2 = 16'h5; y2 = 16'h10;
        repeat(20) @(posedge clk);
        #1;

        check_outputs(16'h0, 16'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ECC_Point_Addition Testbench");
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
        $dumpvars(0,clk, reset, x1, x2, y1, y2, x3, y3);
    end

endmodule
