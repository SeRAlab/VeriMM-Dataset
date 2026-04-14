`timescale 1ns/1ps

module LU_Decomposition_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a11;
    reg [15:0] a12;
    reg [15:0] a21;
    reg [15:0] a22;
    reg clk;
    reg rst;
    wire [15:0] l11;
    wire [15:0] l12;
    wire [15:0] l21;
    wire [15:0] l22;
    wire [15:0] u11;
    wire [15:0] u12;
    wire [15:0] u21;
    wire [15:0] u22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LU_Decomposition dut (
        .a11(a11),
        .a12(a12),
        .a21(a21),
        .a22(a22),
        .clk(clk),
        .rst(rst),
        .l11(l11),
        .l12(l12),
        .l21(l21),
        .l22(l22),
        .u11(u11),
        .u12(u12),
        .u21(u21),
        .u22(u22)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a11 = 16'h0;
            a12 = 16'h0;
            a21 = 16'h0;
            a22 = 16'h0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTestcase %0d: Identity Matrix", test_num);
            a11 = 16'h0001; a12 = 16'h0000; a21 = 16'h0000; a22 = 16'h0001;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0001, 16'h0000, 16'h0000, 16'h0001, 16'h0001, 16'h0000, 16'h0000, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTestcase %0d: Matrix A = [2 4; 4 10]", test_num);
            a11 = 16'h0002; a12 = 16'h0004; a21 = 16'h0004; a22 = 16'h000A;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0001, 16'h0000, 16'h0002, 16'h0001, 16'h0002, 16'h0004, 16'h0000, 16'h0002);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTestcase %0d: Matrix A = [5 10; 15 40]", test_num);
            a11 = 16'h0005; a12 = 16'h000A; a21 = 16'h000F; a22 = 16'h0028;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0001, 16'h0000, 16'h0003, 16'h0001, 16'h0005, 16'h000A, 16'h0000, 16'h000A);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTestcase %0d: Matrix A = [3 6; 9 25]", test_num);
            a11 = 16'h0003; a12 = 16'h0006; a21 = 16'h0009; a22 = 16'h0019;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0001, 16'h0000, 16'h0003, 16'h0001, 16'h0003, 16'h0006, 16'h0000, 16'h0007);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTestcase %0d: Matrix A = [10 20; 30 100]", test_num);
            a11 = 16'h000A; a12 = 16'h0014; a21 = 16'h001E; a22 = 16'h0064;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(16'h0001, 16'h0000, 16'h0003, 16'h0001, 16'h000A, 16'h0014, 16'h0000, 16'h0028);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LU_Decomposition Testbench");
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
        input [15:0] expected_l11;
        input [15:0] expected_l12;
        input [15:0] expected_l21;
        input [15:0] expected_l22;
        input [15:0] expected_u11;
        input [15:0] expected_u12;
        input [15:0] expected_u21;
        input [15:0] expected_u22;
        begin
            if (expected_l11 === (expected_l11 ^ l11 ^ expected_l11) &&
                expected_l12 === (expected_l12 ^ l12 ^ expected_l12) &&
                expected_l21 === (expected_l21 ^ l21 ^ expected_l21) &&
                expected_l22 === (expected_l22 ^ l22 ^ expected_l22) &&
                expected_u11 === (expected_u11 ^ u11 ^ expected_u11) &&
                expected_u12 === (expected_u12 ^ u12 ^ expected_u12) &&
                expected_u21 === (expected_u21 ^ u21 ^ expected_u21) &&
                expected_u22 === (expected_u22 ^ u22 ^ expected_u22)) begin
                $display("PASS");
                $display("  Outputs: l11=%h, l12=%h, l21=%h, l22=%h, u11=%h, u12=%h, u21=%h, u22=%h",
                         l11, l12, l21, l22, u11, u12, u21, u22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l11=%h, l12=%h, l21=%h, l22=%h, u11=%h, u12=%h, u21=%h, u22=%h",
                         expected_l11, expected_l12, expected_l21, expected_l22, expected_u11, expected_u12, expected_u21, expected_u22);
                $display("  Got:      l11=%h, l12=%h, l21=%h, l22=%h, u11=%h, u12=%h, u21=%h, u22=%h",
                         l11, l12, l21, l22, u11, u12, u21, u22);
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
        $dumpvars(0,a11, a12, a21, a22, clk, rst, l11, l12, l21, l22, u11, u12, u21, u22);
    end

endmodule
