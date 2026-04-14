`timescale 1ns/1ps

module chacha_quarter_round_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg [31:0] c;
    reg clk;
    reg [31:0] d;
    reg rst;
    wire [31:0] a_out;
    wire [31:0] b_out;
    wire [31:0] c_out;
    wire [31:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha_quarter_round dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .rst(rst),
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
            rst = 1;
            a = 0;
            b = 0;
            c = 0;
            d = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nTest Case 001: All Zeros");
            reset_dut();
            a = 32'h00000000;
            b = 32'h00000000;
            c = 32'h00000000;
            d = 32'h00000000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h00000000, 32'h00000000, 32'h00000000, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            $display("\nTest Case 002: RFC 7539 Test Vector");
            reset_dut();
            a = 32'h11111111;
            b = 32'h01020304;
            c = 32'h9b8d6f43;
            d = 32'h01234567;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hea2a92f4, 32'hcb1cf8ce, 32'h4581472e, 32'h5881c4bb);
        end
        endtask

    task testcase003;

        begin
            $display("\nTest Case 003: Simple Incremental Values");
            reset_dut();
            a = 32'h00000001;
            b = 32'h00000002;
            c = 32'h00000003;
            d = 32'h00000004;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h70001003, 32'h8b89b9bb, 32'h07170373, 32'h07100370);
        end
        endtask

    task testcase004;

        begin
            $display("\nTest Case 004: All Ones (Overflow check)");
            reset_dut();
            a = 32'hffffffff;
            b = 32'hffffffff;
            c = 32'hffffffff;
            d = 32'hffffffff;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'heffffffd, 32'hff81090f, 32'hefff0ded, 32'heffffdef);
        end
        endtask

    task testcase005;

        begin
            $display("\nTest Case 005: Boundary Rotation Check");
            reset_dut();
            a = 32'h80000000;
            b = 32'h00000000;
            c = 32'h00000000;
            d = 32'h00000001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h98000001, 32'hc0c0cc8c, 32'h01818198, 32'h01800198);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha_quarter_round Testbench");
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
        $dumpvars(0,a, b, c, clk, d, rst, a_out, b_out, c_out, d_out);
    end

endmodule
