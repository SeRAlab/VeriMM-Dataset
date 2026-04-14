`timescale 1ns/1ps

module cholesky_decomposition_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a11;
    reg [7:0] a12;
    reg [7:0] a21;
    reg [7:0] a22;
    reg clk;
    reg enable;
    wire [7:0] l11;
    wire [7:0] l21;
    wire [7:0] l22;

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
        .enable(enable),
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
            enable = 0;
            a11 = 0;
            a12 = 0;
            a21 = 0;
            a22 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Identity Matrix", test_num);
            reset_dut();
            a11 = 8'd1; a12 = 8'd0; a21 = 8'd0; a22 = 8'd1;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd1, 8'd0, 8'd1);
            enable = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Diagonal Matrix (4, 9)", test_num);
            reset_dut();
            a11 = 8'd4; a12 = 8'd0; a21 = 8'd0; a22 = 8'd9;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd2, 8'd0, 8'd3);
            enable = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Standard Matrix (4, 6, 6, 25)", test_num);
            reset_dut();
            a11 = 8'd4; a12 = 8'd6; a21 = 8'd6; a22 = 8'd25;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd2, 8'd3, 8'd4);
            enable = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Small Output Values (16, 8, 8, 5)", test_num);
            reset_dut();
            a11 = 8'd16; a12 = 8'd8; a21 = 8'd8; a22 = 8'd5;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd4, 8'd2, 8'd1);
            enable = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Integer Result (25, 10, 10, 20)", test_num);
            reset_dut();
            a11 = 8'd25; a12 = 8'd10; a21 = 8'd10; a22 = 8'd20;
            enable = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(8'd5, 8'd2, 8'd4);
            enable = 0;
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
        input [7:0] expected_l11;
        input [7:0] expected_l21;
        input [7:0] expected_l22;
        begin
            if (expected_l11 === (expected_l11 ^ l11 ^ expected_l11) &&
                expected_l21 === (expected_l21 ^ l21 ^ expected_l21) &&
                expected_l22 === (expected_l22 ^ l22 ^ expected_l22)) begin
                $display("PASS");
                $display("  Outputs: l11=%h, l21=%h, l22=%h",
                         l11, l21, l22);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: l11=%h, l21=%h, l22=%h",
                         expected_l11, expected_l21, expected_l22);
                $display("  Got:      l11=%h, l21=%h, l22=%h",
                         l11, l21, l22);
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
        $dumpvars(0,a11, a12, a21, a22, clk, enable, l11, l21, l22);
    end

endmodule
