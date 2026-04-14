`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] w0i;
    reg [31:0] w0r;
    reg [15:0] xi;
    reg [15:0] xr;
    reg [15:0] yi;
    reg [15:0] yr;
    wire [15:0] ai;
    wire [15:0] ar;
    wire [15:0] bi;
    wire [15:0] br;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .w0i(w0i),
        .w0r(w0r),
        .xi(xi),
        .xr(xr),
        .yi(yi),
        .yr(yr),
        .ai(ai),
        .ar(ar),
        .bi(bi),
        .br(br)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            xr = 16'd0; xi = 16'd0;
            yr = 16'd0; yi = 16'd0;
            w0r = 32'd0; w0i = 32'd0;
            #1;

            check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            xr = 16'd100; xi = 16'd200;
            yr = 16'd50; yi = 16'd60;
            w0r = 32'h40000000; w0i = 32'h00000000;
            #1;

            check_outputs(16'h0104, 16'h0096, 16'h008C, 16'h0032);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            xr = 16'd100; xi = 16'd200;
            yr = 16'd50; yi = 16'd60;
            w0r = 32'h00000000; w0i = 32'h40000000;
            #1;

            check_outputs(16'h00FA, 16'h0028, 16'h0096, 16'h00A0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            xr = -16'd100; xi = -16'd200;
            yr = -16'd50; yi = -60;
            w0r = 32'h40000000; w0i = 32'h0;
            #1;

            check_outputs(16'hFEFC, 16'hFF6A, 16'hFF74, 16'hFFCE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            xr = 16'd10; xi = 16'd10;
            yr = 16'd20; yi = 16'd0;
            w0r = 32'h20000000; w0i = 32'h20000000;
            #1;

            check_outputs(16'h0014, 16'h0014, 16'h0000, 16'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            xr = 16'd10000; xi = 16'd10000;
            yr = 16'd5000; yi = 16'd5000;
            w0r = 32'h40000000; w0i = 32'h0;
            #1;

            check_outputs(16'h3A98, 16'h3A98, 16'h1388, 16'h1388);
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
        input [15:0] expected_ai;
        input [15:0] expected_ar;
        input [15:0] expected_bi;
        input [15:0] expected_br;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ai === (expected_ai ^ ai ^ expected_ai) &&
                expected_ar === (expected_ar ^ ar ^ expected_ar) &&
                expected_bi === (expected_bi ^ bi ^ expected_bi) &&
                expected_br === (expected_br ^ br ^ expected_br)) begin
                $display("PASS");
                $display("  Outputs: ai=%h, ar=%h, bi=%h, br=%h",
                         ai, ar, bi, br);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ai=%h, ar=%h, bi=%h, br=%h",
                         expected_ai, expected_ar, expected_bi, expected_br);
                $display("  Got:      ai=%h, ar=%h, bi=%h, br=%h",
                         ai, ar, bi, br);
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

endmodule
