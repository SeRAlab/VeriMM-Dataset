`timescale 1ns/1ps

module cholesky_decomposition_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a11;
    reg [15:0] a12;
    reg [15:0] a21;
    reg [15:0] a22;
    reg clk;
    reg rst;
    reg start;
    wire done;
    wire [15:0] l11;
    wire [15:0] l21;
    wire [15:0] l22;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    cholesky_decomposition dut (
        .a11(a11),
        .a12(a12),
        .a21(a21),
        .a22(a22),
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .l11(l11),
        .l21(l21),
        .l22(l22)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            a11 = 0;
            a12 = 0;
            a21 = 0;
            a22 = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("\nTestcase %0d: Identity Matrix", test_num);
            a11 = 16'd1; a12 = 16'd0; a21 = 16'd0; a22 = 16'd1;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd1, 16'd0, 16'd1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("\nTestcase %0d: Simple Diagonal Matrix", test_num);
            a11 = 16'd4; a12 = 16'd0; a21 = 16'd0; a22 = 16'd9;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd2, 16'd0, 16'd3);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("\nTestcase %0d: Integer Result Matrix 1", test_num);
            a11 = 16'd16; a12 = 16'd8; a21 = 16'd8; a22 = 16'd13;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd4, 16'd2, 16'd3);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("\nTestcase %0d: Integer Result Matrix 2", test_num);
            a11 = 16'd9; a12 = 16'd12; a21 = 16'd12; a22 = 16'd41;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd3, 16'd4, 16'd5);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("\nTestcase %0d: Larger Integer Values", test_num);
            a11 = 16'd100; a12 = 16'd50; a21 = 16'd50; a22 = 16'd125;
            start = 1;
            @(posedge clk);
            start = 0;

            wait(done);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 16'd10, 16'd5, 16'd10);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("cholesky_decomposition Testbench");
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
        input expected_done;
        input [15:0] expected_l11;
        input [15:0] expected_l21;
        input [15:0] expected_l22;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_l11 === (expected_l11 ^ l11 ^ expected_l11) &&
                expected_l21 === (expected_l21 ^ l21 ^ expected_l21) &&
                expected_l22 === (expected_l22 ^ l22 ^ expected_l22)) begin
                $display("PASS");
                $display("  Outputs: done=%b, l11=%h, l21=%h, l22=%h",
                         done, l11, l21, l22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, l11=%h, l21=%h, l22=%h",
                         expected_done, expected_l11, expected_l21, expected_l22);
                $display("  Got:      done=%b, l11=%h, l21=%h, l22=%h",
                         done, l11, l21, l22);
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
        $dumpvars(0,a11, a12, a21, a22, clk, rst, start, done, l11, l21, l22);
    end

endmodule
