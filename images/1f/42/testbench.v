`timescale 1ns/1ps

module quarter_round_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a_in;
    reg [31:0] b_in;
    reg [31:0] c_in;
    reg clk;
    reg [31:0] d_in;
    reg rst_n;
    wire [31:0] a_out;
    wire [31:0] b_out;
    wire [31:0] c_out;
    wire [31:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    quarter_round dut (
        .a_in(a_in),
        .b_in(b_in),
        .c_in(c_in),
        .clk(clk),
        .d_in(d_in),
        .rst_n(rst_n),
        .a_out(a_out),
        .b_out(b_out),
        .c_out(c_out),
        .d_out(d_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            a_in = 32'h0;
            b_in = 32'h0;
            c_in = 32'h0;
            d_in = 32'h0;
            @(posedge clk);
            #2 rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Values", test_num);
            a_in = 32'h11111111;
            b_in = 32'h22222222;
            c_in = 32'h33333333;
            d_in = 32'h44444444;


            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hbbbbbbbb, 32'hffffff7f, 32'h77777776, 32'hcccccccc);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Inputs", test_num);
            a_in = 32'h00000000;
            b_in = 32'h00000000;
            c_in = 32'h00000000;
            d_in = 32'h00000000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: RFC-style Mixed Inputs", test_num);
            a_in = 32'h11111111;
            b_in = 32'h01020304;
            c_in = 32'h9b8d6f43;
            d_in = 32'h01234567;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hea2a92f4, 32'hcb1cf8ce, 32'h4581472e, 32'h5881c4bb);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: All Bits Set", test_num);
            a_in = 32'hffffffff;
            b_in = 32'hffffffff;
            c_in = 32'hffffffff;
            d_in = 32'hffffffff;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hbfff7fff, 32'h5fbf7fff, 32'hdfffbfff, 32'hbfff7fff);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Rotation (High Bit)", test_num);
            a_in = 32'h80000000;
            b_in = 32'h00000001;
            c_in = 32'h00000000;
            d_in = 32'h00000000;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h80000001, 32'h80800080, 32'h00010101, 32'h01010000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test Case %0d: Checkerboard Pattern", test_num);
            a_in = 32'hAAAAAAAA;
            b_in = 32'h55555555;
            c_in = 32'hAAAAAAAA;
            d_in = 32'h55555555;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h66666665, 32'h90909090, 32'h6b6b6b6b, 32'hffffffff);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("quarter_round Testbench");
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
        input [31:0] expected_a_out;
        input [31:0] expected_b_out;
        input [31:0] expected_c_out;
        input [31:0] expected_d_out;
        begin
            if (expected_a_out === (expected_a_out ^ a_out ^ expected_a_out) &&
                expected_b_out === (expected_b_out ^ b_out ^ expected_b_out) &&
                expected_c_out === (expected_c_out ^ c_out ^ expected_c_out) &&
                expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: a_out=%h, b_out=%h, c_out=%h, d_out=%h",
                         a_out, b_out, c_out, d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a_out=%h, b_out=%h, c_out=%h, d_out=%h",
                         expected_a_out, expected_b_out, expected_c_out, expected_d_out);
                $display("  Got:      a_out=%h, b_out=%h, c_out=%h, d_out=%h",
                         a_out, b_out, c_out, d_out);
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
        $dumpvars(0,a_in, b_in, c_in, clk, d_in, rst_n, a_out, b_out, c_out, d_out);
    end

endmodule
