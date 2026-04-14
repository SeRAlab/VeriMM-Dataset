`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] Hexs;
    reg [7:0] LES;
    reg [2:0] Scan;
    reg [7:0] point;
    wire [3:0] AN;
    wire [3:0] Hexo;
    wire LE;
    wire p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Hexs(Hexs),
        .LES(LES),
        .Scan(Scan),
        .point(point),
        .AN(AN),
        .Hexo(Hexo),
        .LE(LE),
        .p(p)
    );
    task testcase001;

        begin
            $display("Running testcase001: Scan digit 0");
            test_num = 1;
            Hexs = 32'h87654321;
            LES = 8'b11110000;
            point = 8'b10101010;
            Scan = 3'd0;
            #10;

            #1;


            check_outputs(4'd0, 4'h1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Scan digit 1");
            test_num = 2;
            Hexs = 32'h87654321;
            LES = 8'b11110000;
            point = 8'b10101010;
            Scan = 3'd1;
            #10;

            #1;


            check_outputs(4'd1, 4'h2, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Scan digit 2");
            test_num = 3;
            Hexs = 32'h87654321;
            LES = 8'b11110000;
            point = 8'b10101010;
            Scan = 3'd2;
            #10;

            #1;


            check_outputs(4'd2, 4'h3, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Scan digit 3");
            test_num = 4;
            Hexs = 32'h87654321;
            LES = 8'b11110000;
            point = 8'b10101010;
            Scan = 3'd3;
            #10;

            #1;


            check_outputs(4'd3, 4'h4, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Scan digit 4");
            test_num = 5;
            Hexs = 32'h87654321;
            LES = 8'b11110000;
            point = 8'b10101010;
            Scan = 3'd4;
            #10;

            #1;


            check_outputs(4'd4, 4'h5, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Scan digit 5");
            test_num = 6;
            Hexs = 32'h87654321;
            LES = 8'b11110000;
            point = 8'b10101010;
            Scan = 3'd5;
            #10;

            #1;


            check_outputs(4'd5, 4'h6, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Scan digit 6");
            test_num = 7;
            Hexs = 32'h87654321;
            LES = 8'b11110000;
            point = 8'b10101010;
            Scan = 3'd6;
            #10;

            #1;


            check_outputs(4'd6, 4'h7, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Scan digit 7");
            test_num = 8;
            Hexs = 32'h87654321;
            LES = 8'b11110000;
            point = 8'b10101010;
            Scan = 3'd7;
            #10;

            #1;


            check_outputs(4'd7, 4'h8, 1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Running testcase009: Check hexadecimal A-F");
            test_num = 9;
            Hexs = 32'hABCDEF09;
            LES = 8'hFF;
            point = 8'h00;
            Scan = 3'd2;
            #10;
            #1;

            check_outputs(4'd2, 4'hF, 1'b1, 1'b0);
        end
        endtask

    task testcase010;

        begin
            $display("Running testcase010: All Zeroes");
            test_num = 10;
            Hexs = 32'h0;
            LES = 8'h0;
            point = 8'h0;
            Scan = 3'd4;
            #10;
            #1;

            check_outputs(4'd4, 4'h0, 1'b0, 1'b0);
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
        input [3:0] expected_AN;
        input [3:0] expected_Hexo;
        input expected_LE;
        input expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_AN === (expected_AN ^ AN ^ expected_AN) &&
                expected_Hexo === (expected_Hexo ^ Hexo ^ expected_Hexo) &&
                expected_LE === (expected_LE ^ LE ^ expected_LE) &&
                expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: AN=%h, Hexo=%h, LE=%b, p=%b",
                         AN, Hexo, LE, p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AN=%h, Hexo=%h, LE=%b, p=%b",
                         expected_AN, expected_Hexo, expected_LE, expected_p);
                $display("  Got:      AN=%h, Hexo=%h, LE=%b, p=%b",
                         AN, Hexo, LE, p);
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
