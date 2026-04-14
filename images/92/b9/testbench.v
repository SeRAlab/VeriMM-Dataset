`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg divider_begin;
    reg [1:0] sign;
    wire divider_end;
    wire [63:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .divider_begin(divider_begin),
        .sign(sign),
        .divider_end(divider_end),
        .z(z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 32'd100;
            b = 32'd7;
            sign = 2'd2;
            divider_begin = 1'b1;


            #1;



            check_outputs(1'b0, 64'h00000002_0000000E);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 32'd5;
            b = 32'd10;
            sign = 2'd2;
            divider_begin = 1'b1;

            #1;


            check_outputs(1'b0, 64'h00000005_00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 32'd20;
            b = 32'd6;
            sign = 2'd1;
            divider_begin = 1'b1;

            #1;


            check_outputs(1'b0, 64'h00000002_00000003);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = -32'd20;
            b = 32'd6;
            sign = 2'd1;
            divider_begin = 1'b1;

            #1;


            check_outputs(1'b0, 64'hFFFFFFFE_FFFFFFFD);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 32'd20;
            b = -32'd6;
            sign = 2'd1;
            divider_begin = 1'b1;

            #1;


            check_outputs(1'b0, 64'h00000002_FFFFFFFD);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = -32'd20;
            b = -32'd6;
            sign = 2'd1;
            divider_begin = 1'b1;

            #1;


            check_outputs(1'b0, 64'hFFFFFFFE_00000003);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 32'd0;
            b = 32'd0;
            sign = 2'd2;
            divider_begin = 1'b1;

            #1;


            check_outputs(1'b1, 64'h00000000_00000000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 32'd0;
            b = 32'd5;
            sign = 2'd2;
            divider_begin = 1'b1;

            #1;


            check_outputs(1'b0, 64'h00000000_00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            a = 32'hFFFFFFFF;
            b = 32'h2;
            sign = 2'd2;
            divider_begin = 1'b1;

            #1;


            check_outputs(1'b0, 64'h00000001_7FFFFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            a = 32'h80000000;
            b = 32'h1;
            sign = 2'd1;
            divider_begin = 1'b1;

            #1;


            check_outputs(1'b0, 64'h00000000_80000000);
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
        input expected_divider_end;
        input [63:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_divider_end === (expected_divider_end ^ divider_end ^ expected_divider_end) &&
                expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: divider_end=%b, z=%h",
                         divider_end, z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: divider_end=%b, z=%h",
                         expected_divider_end, expected_z);
                $display("  Got:      divider_end=%b, z=%h",
                         divider_end, z);
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
