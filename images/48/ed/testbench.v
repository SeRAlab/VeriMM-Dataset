`timescale 1ns/1ps

module divider_pipe_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] div_a;
    reg [15:0] div_b;
    reg i_en;
    reg rst_n;
    wire o_en;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    divider_pipe_16bit dut (
        .clk(clk),
        .div_a(div_a),
        .div_b(div_b),
        .i_en(i_en),
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
            div_a = 0;
            div_b = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic division (100 / 5)");
            reset_dut();
            @(posedge clk);
            i_en = 1;
            div_a = 16'd100;
            div_b = 16'd5;
            @(posedge clk);
            i_en = 0;


            wait(o_en == 1);


            #1;



            check_outputs(1'b1, 16'd20);
            @(posedge clk);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Quotient is zero (50 / 100)");
            reset_dut();
            @(posedge clk);
            i_en = 1;
            div_a = 16'd50;
            div_b = 16'd100;
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
            $display("Testcase 003: Large dividend (65535 / 2)");
            reset_dut();
            @(posedge clk);
            i_en = 1;
            div_a = 16'hFFFF;
            div_b = 16'd2;
            @(posedge clk);
            i_en = 0;

            wait(o_en == 1);
            #1;

            check_outputs(1'b1, 16'd32767);
            @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Division by 1 (500 / 1)");
            reset_dut();
            @(posedge clk);
            i_en = 1;
            div_a = 16'd500;
            div_b = 16'd1;
            @(posedge clk);
            i_en = 0;

            wait(o_en == 1);
            #1;

            check_outputs(1'b1, 16'd500);
            @(posedge clk);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Dividend equals Divisor (255 / 255)");
            reset_dut();
            @(posedge clk);
            i_en = 1;
            div_a = 16'd255;
            div_b = 16'd255;
            @(posedge clk);
            i_en = 0;

            wait(o_en == 1);
            #1;

            check_outputs(1'b1, 16'd1);
            @(posedge clk);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Maximum dividend (65535 / 255)");
            reset_dut();
            @(posedge clk);
            i_en = 1;
            div_a = 16'hFFFF;
            div_b = 16'd255;
            @(posedge clk);
            i_en = 0;

            wait(o_en == 1);
            #1;

            check_outputs(1'b1, 16'd257);
            @(posedge clk);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Zero dividend (0 / 123)");
            reset_dut();
            @(posedge clk);
            i_en = 1;
            div_a = 16'd0;
            div_b = 16'd123;
            @(posedge clk);
            i_en = 0;

            wait(o_en == 1);
            #1;

            check_outputs(1'b1, 16'd0);
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
        $display("divider_pipe_16bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        $dumpvars(0,clk, div_a, div_b, i_en, rst_n, o_en, result);
    end

endmodule
