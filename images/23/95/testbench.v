`timescale 1ns/1ps

module matrix_inversion_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg clk;
    reg [15:0] d;
    reg rst;
    wire [15:0] inv_a;
    wire [15:0] inv_b;
    wire [15:0] inv_c;
    wire [15:0] inv_d;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inversion dut (
        .a(a),
        .b(b),
        .c(c),
        .clk(clk),
        .d(d),
        .rst(rst),
        .inv_a(inv_a),
        .inv_b(inv_b),
        .inv_c(inv_c),
        .inv_d(inv_d),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            a = 16'd0;
            b = 16'd0;
            c = 16'd0;
            d = 16'd1;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Identity Matrix", test_num);
            a = 16'd1; b = 16'd0; c = 16'd0; d = 16'd1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd1, 16'd0, 16'd0, 16'd1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Swap Matrix (det = -1)", test_num);
            a = 16'd0; b = 16'd1; c = 16'd1; d = 16'd0;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd0, 16'd1, 16'd1, 16'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Determinant = 1", test_num);
            a = 16'd3; b = 16'd2; c = 16'd1; d = 16'd1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd1, 16'hFFFE, 16'hFFFF, 16'd3, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Determinant = -1", test_num);
            a = 16'd1; b = 16'd2; c = 16'd2; d = 16'd3;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'hFFFD, 16'd2, 16'd2, 16'hFFFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Singular Matrix (det = 0)", test_num);
            a = 16'd1; b = 16'd1; c = 16'd1; d = 16'd1;
            repeat(2) @(posedge clk);

            if (valid === 1'b0) begin
                pass_count = pass_count + 1;
                $display("PASS: valid correctly deasserted");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: valid should be low for singular matrix");
            end
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Negative Input Values", test_num);
            a = 16'd1; b = 16'hFFFF; c = 16'd0; d = 16'd1;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'd1, 16'd1, 16'd0, 16'd1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_inversion Testbench");
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
        input [15:0] expected_inv_a;
        input [15:0] expected_inv_b;
        input [15:0] expected_inv_c;
        input [15:0] expected_inv_d;
        input expected_valid;
        begin
            if (expected_inv_a === (expected_inv_a ^ inv_a ^ expected_inv_a) &&
                expected_inv_b === (expected_inv_b ^ inv_b ^ expected_inv_b) &&
                expected_inv_c === (expected_inv_c ^ inv_c ^ expected_inv_c) &&
                expected_inv_d === (expected_inv_d ^ inv_d ^ expected_inv_d) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: inv_a=%h, inv_b=%h, inv_c=%h, inv_d=%h, valid=%b",
                         inv_a, inv_b, inv_c, inv_d, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inv_a=%h, inv_b=%h, inv_c=%h, inv_d=%h, valid=%b",
                         expected_inv_a, expected_inv_b, expected_inv_c, expected_inv_d, expected_valid);
                $display("  Got:      inv_a=%h, inv_b=%h, inv_c=%h, inv_d=%h, valid=%b",
                         inv_a, inv_b, inv_c, inv_d, valid);
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
        $dumpvars(0,a, b, c, clk, d, rst, inv_a, inv_b, inv_c, inv_d, valid);
    end

endmodule
