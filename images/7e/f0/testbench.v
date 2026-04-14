`timescale 1ns/1ps

module multiplier_pipe_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i_en;
    reg [7:0] mul_a;
    reg [7:0] mul_b;
    reg rst_n;
    wire o_en;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_pipe_8bit dut (
        .clk(clk),
        .i_en(i_en),
        .mul_a(mul_a),
        .mul_b(mul_b),
        .rst_n(rst_n),
        .o_en(o_en),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            i_en = 0;
            mul_a = 0;
            mul_b = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic multiplication (10 * 12)", test_num);
            reset_dut();

            mul_a = 8'd10;
            mul_b = 8'd12;
            i_en = 1;
            @(posedge clk);
            i_en = 0;


            wait(o_en == 1);
            #1;

            check_outputs(1'b1, 16'd120);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by zero (255 * 0)", test_num);
            reset_dut();

            mul_a = 8'd255;
            mul_b = 8'd0;
            i_en = 1;
            @(posedge clk);
            i_en = 0;

            wait(o_en == 1);
            #1;

            check_outputs(1'b1, 16'd0);
            @(posedge clk);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum values (255 * 255)", test_num);
            reset_dut();

            mul_a = 8'hFF;
            mul_b = 8'hFF;
            i_en = 1;
            @(posedge clk);
            i_en = 0;

            wait(o_en == 1);
            #1;

            check_outputs(1'b1, 16'hFE01);
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity (1 * 127)", test_num);
            reset_dut();

            mul_a = 8'd1;
            mul_b = 8'd127;
            i_en = 1;
            @(posedge clk);
            i_en = 0;

            wait(o_en == 1);
            #1;

            check_outputs(1'b1, 16'd127);
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Powers of two (16 * 16)", test_num);
            reset_dut();

            mul_a = 8'd16;
            mul_b = 8'd16;
            i_en = 1;
            @(posedge clk);
            i_en = 0;

            wait(o_en == 1);
            #1;

            check_outputs(1'b1, 16'd256);
            @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Prime numbers (13 * 17)", test_num);
            reset_dut();

            mul_a = 8'd13;
            mul_b = 8'd17;
            i_en = 1;
            @(posedge clk);
            i_en = 0;

            wait(o_en == 1);
            #1;

            check_outputs(1'b1, 16'd221);
            @(posedge clk);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_pipe_8bit Testbench");
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
        input expected_o_en;
        input [15:0] expected_result;
        begin
            if (expected_o_en === (expected_o_en ^ o_en ^ expected_o_en) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: o_en=%b, result=%h",
                         o_en, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_en=%b, result=%h",
                         expected_o_en, expected_result);
                $display("  Got:      o_en=%b, result=%h",
                         o_en, result);
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
        $dumpvars(0,clk, i_en, mul_a, mul_b, rst_n, o_en, result);
    end

endmodule
