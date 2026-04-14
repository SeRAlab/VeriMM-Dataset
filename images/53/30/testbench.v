`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg ci;
    wire co;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ci(ci),
        .co(co),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 10 - 5 - 0", test_num);
            a = 8'd10;
            b = 8'd5;
            ci = 1'b0;
            #1;

            check_outputs(1'b0, 8'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 10 - 5 - 1", test_num);
            a = 8'd10;
            b = 8'd5;
            ci = 1'b1;
            #1;

            check_outputs(1'b0, 8'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 5 - 5 - 0", test_num);
            a = 8'd5;
            b = 8'd5;
            ci = 1'b0;
            #1;

            check_outputs(1'b0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 5 - 10 - 0", test_num);
            a = 8'd5;
            b = 8'd10;
            ci = 1'b0;

            #1;


            check_outputs(1'b1, 8'hFB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 0 - 0 - 1", test_num);
            a = 8'd0;
            b = 8'd0;
            ci = 1'b1;

            #1;


            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 255 - 128 - 0", test_num);
            a = 8'hFF;
            b = 8'h80;
            ci = 1'b0;
            #1;

            check_outputs(1'b0, 8'h7F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 10 - 11 - 0", test_num);
            a = 8'd10;
            b = 8'd11;
            ci = 1'b0;
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 128 - 128 - 1", test_num);
            a = 8'd128;
            b = 8'd128;
            ci = 1'b1;
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 0 - 255 - 0", test_num);
            a = 8'd0;
            b = 8'd255;
            ci = 1'b0;

            #1;


            check_outputs(1'b1, 8'h01);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 255 - 0 - 0", test_num);
            a = 8'hFF;
            b = 8'h00;
            ci = 1'b0;
            #1;

            check_outputs(1'b0, 8'hFF);
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
        input expected_co;
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_co === (expected_co ^ co ^ expected_co) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: co=%b, y=%h",
                         co, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: co=%b, y=%h",
                         expected_co, expected_y);
                $display("  Got:      co=%b, y=%h",
                         co, y);
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
