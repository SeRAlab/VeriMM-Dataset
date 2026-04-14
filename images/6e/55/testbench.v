`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] i;
    wire [2:0] len;
    wire [7:0] o0;
    wire [7:0] o1;
    wire [7:0] o2;
    wire [7:0] o3;
    wire [7:0] o4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i(i),
        .len(len),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .o3(o3),
        .o4(o4)
    );
    task testcase001;

        begin
            test_num = 1;
            i = 32'h00000000;
            $display("Test %0d: All zeros input", test_num);

            #1;


            check_outputs(3'd1, 8'h00, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            i = 32'h0000007F;
            $display("Test %0d: Maximum 1-byte value (127)", test_num);
            #1;

            check_outputs(3'd1, 8'h7F, 8'h00, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            i = 32'h00000080;
            $display("Test %0d: Minimum 2-byte value (128)", test_num);

            #1;


            check_outputs(3'd2, 8'h80, 8'h01, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            i = 32'h00003FFF;
            $display("Test %0d: Maximum 2-byte value (16383)", test_num);
            #1;

            check_outputs(3'd2, 8'hFF, 8'h7F, 8'h00, 8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            i = 32'h00004000;
            $display("Test %0d: Minimum 3-byte value (16384)", test_num);
            #1;

            check_outputs(3'd3, 8'h80, 8'h80, 8'h01, 8'h00, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            i = 32'h001FFFFF;
            $display("Test %0d: Maximum 3-byte value (2097151)", test_num);
            #1;

            check_outputs(3'd3, 8'hFF, 8'hFF, 8'h7F, 8'h00, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            i = 32'h00200000;
            $display("Test %0d: Minimum 4-byte value (2097152)", test_num);
            #1;

            check_outputs(3'd4, 8'h80, 8'h80, 8'h80, 8'h01, 8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            i = 32'h0FFFFFFF;
            $display("Test %0d: Maximum 4-byte value (268435455)", test_num);
            #1;

            check_outputs(3'd4, 8'hFF, 8'hFF, 8'hFF, 8'h7F, 8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            i = 32'h10000000;
            $display("Test %0d: Minimum 5-byte value (268435456)", test_num);
            #1;

            check_outputs(3'd5, 8'h80, 8'h80, 8'h80, 8'h80, 8'h01);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            i = 32'hFFFFFFFF;
            $display("Test %0d: Maximum possible 32-bit input", test_num);
            #1;

            check_outputs(3'd5, 8'hFF, 8'hFF, 8'hFF, 8'hFF, 8'h0F);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            i = 32'h00004001;
            $display("Test %0d: Sparse input (non-zero high segment)", test_num);
            #1;

            check_outputs(3'd3, 8'h81, 8'h80, 8'h01, 8'h00, 8'h00);
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
        testcase011();
        
        
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
        input [2:0] expected_len;
        input [7:0] expected_o0;
        input [7:0] expected_o1;
        input [7:0] expected_o2;
        input [7:0] expected_o3;
        input [7:0] expected_o4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_len === (expected_len ^ len ^ expected_len) &&
                expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_o3 === (expected_o3 ^ o3 ^ expected_o3) &&
                expected_o4 === (expected_o4 ^ o4 ^ expected_o4)) begin
                $display("PASS");
                $display("  Outputs: len=%h, o0=%h, o1=%h, o2=%h, o3=%h, o4=%h",
                         len, o0, o1, o2, o3, o4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: len=%h, o0=%h, o1=%h, o2=%h, o3=%h, o4=%h",
                         expected_len, expected_o0, expected_o1, expected_o2, expected_o3, expected_o4);
                $display("  Got:      len=%h, o0=%h, o1=%h, o2=%h, o3=%h, o4=%h",
                         len, o0, o1, o2, o3, o4);
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
