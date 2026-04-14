`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] a;
    reg [5:0] b;
    reg clk;
    reg [2:0] s;
    wire cf;
    wire of;
    wire [5:0] y;
    wire zf;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .s(s),
        .cf(cf),
        .of(of),
        .y(y),
        .zf(zf)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            s = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            s = 3'b000;
            a = 6'd10;
            b = 6'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 6'd15, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            s = 3'b000;
            a = 6'd63;
            b = 6'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 6'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            s = 3'b000;
            a = 6'b011111;
            b = 6'b000001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 6'b100000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            s = 3'b001;
            a = 6'd20;
            b = 6'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 6'd10, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            s = 3'b001;
            a = 6'd5;
            b = 6'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 6'd59, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            s = 3'b001;
            a = 6'b100000;
            b = 6'b000001;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 6'b011111, 1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            s = 3'b010;
            a = 6'b101010;
            b = 6'b010101;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 6'b000000, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            s = 3'b011;
            a = 6'h0F;
            b = 6'h30;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 6'h3F, 1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            s = 3'b100;
            a = 6'b111111;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 6'b000000, 1'b1);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            s = 3'b101;
            a = 6'h3F;
            b = 6'h3F;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 6'b000000, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input expected_cf;
        input expected_of;
        input [5:0] expected_y;
        input expected_zf;
        begin
            if (expected_cf === (expected_cf ^ cf ^ expected_cf) &&
                expected_of === (expected_of ^ of ^ expected_of) &&
                expected_y === (expected_y ^ y ^ expected_y) &&
                expected_zf === (expected_zf ^ zf ^ expected_zf)) begin
                $display("PASS");
                $display("  Outputs: cf=%b, of=%b, y=%h, zf=%b",
                         cf, of, y, zf);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cf=%b, of=%b, y=%h, zf=%b",
                         expected_cf, expected_of, expected_y, expected_zf);
                $display("  Got:      cf=%b, of=%b, y=%h, zf=%b",
                         cf, of, y, zf);
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
        $dumpvars(0,a, b, clk, s, cf, of, y, zf);
    end

endmodule
