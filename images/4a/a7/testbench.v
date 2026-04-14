`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg mode;
    wire [15:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .mode(mode),
        .P(P)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 8'd0;
            B = 8'd0;
            mode = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Unsigned 10 * 20", test_num);
            A = 8'd10;
            B = 8'd20;
            mode = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd200);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Unsigned 255 * 2", test_num);
            A = 8'hFF;
            B = 8'h02;
            mode = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h01FE);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Unsigned 123 * 0", test_num);
            A = 8'd123;
            B = 8'd0;
            mode = 1'b0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Signed 12 * 5", test_num);
            A = 8'sd12;
            B = 8'sd5;
            mode = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'sd60);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Signed 7 * -3", test_num);
            A = 8'sd7;
            B = -8'sd3;
            mode = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(-16'sd21);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: Signed -10 * 4", test_num);
            A = -8'sd10;
            B = 8'sd4;
            mode = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(-16'sd40);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase %03d: Signed -2 * -8", test_num);
            A = -8'sd2;
            B = -8'sd8;
            mode = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'sd16);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Testcase %03d: Signed -128 * 1 (Edge Case)", test_num);
            A = 8'h80;
            B = 8'h01;
            mode = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'hFF80);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            $display("Testcase %03d: Signed -128 * -1", test_num);
            A = 8'h80;
            B = 8'hFF;
            mode = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd128);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            $display("Testcase %03d: Signed 127 * 127", test_num);
            A = 8'h7F;
            B = 8'h7F;
            mode = 1'b1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd16129);
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
        input [15:0] expected_P;
        begin
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
        $dumpvars(0,A, B, clk, mode, P);
    end

endmodule
