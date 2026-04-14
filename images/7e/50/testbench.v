`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg clk;
    reg ctrl;
    wire [15:0] c;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .ctrl(ctrl),
        .c(c)
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
            ctrl = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned 0 * 0", test_num);
            reset_dut();
            a = 8'h00;
            b = 8'h00;
            ctrl = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned 255 * 255", test_num);
            reset_dut();
            a = 8'hFF;
            b = 8'hFF;
            ctrl = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Unsigned 12 * 10", test_num);
            reset_dut();
            a = 8'd12;
            b = 8'd10;
            ctrl = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'd120);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed 12 * 10", test_num);
            reset_dut();
            a = 8'sd12;
            b = 8'sd10;
            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd120);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed -5 * 10", test_num);
            reset_dut();
            a = -8'sd5;
            b = 8'sd10;
            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd50);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed 20 * -3", test_num);
            reset_dut();
            a = 8'sd20;
            b = -8'sd3;
            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(-16'sd60);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed -10 * -5", test_num);
            reset_dut();
            a = -8'sd10;
            b = -8'sd5;
            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'sd50);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed -128 * -128", test_num);
            reset_dut();
            a = 8'h80;
            b = 8'h80;
            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Signed 127 * -128", test_num);
            reset_dut();
            a = 8'h7F;
            b = 8'h80;
            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hC080);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Toggle Ctrl (0xFF * 0xFF logic check)", test_num);
            reset_dut();
            a = 8'hFF;
            b = 8'hFF;


            ctrl = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0001);


            ctrl = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFE01);
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
        input [15:0] expected_c;
        begin
            if (expected_c === (expected_c ^ c ^ expected_c)) begin
                $display("PASS");
                $display("  Outputs: c=%h",
                         c);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h",
                         expected_c);
                $display("  Got:      c=%h",
                         c);
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
        $dumpvars(0,a, b, clk, ctrl, c);
    end

endmodule
