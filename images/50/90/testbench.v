`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire overflow;
    wire [7:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .overflow(overflow),
        .s(s)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 8'd10; b = 8'd20;
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 8'd70; b = 8'd70;
            #1;

            check_outputs(1'b1, 8'd140);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = -8'd10; b = -8'd20;
            #1;

            check_outputs(1'b0, -8'd30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = -8'd70; b = -8'd70;
            #1;

            check_outputs(1'b1, 8'h74);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 8'd50; b = -8'd20;
            #1;

            check_outputs(1'b0, 8'd30);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 8'h7F; b = 8'd0;
            #1;

            check_outputs(1'b0, 8'h7F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 8'h80; b = 8'd0;
            #1;

            check_outputs(1'b0, 8'h80);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 8'h7F; b = 8'd1;
            #1;

            check_outputs(1'b1, 8'h80);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a = 8'h80; b = 8'hFF;
            #1;

            check_outputs(1'b1, 8'h7F);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            a = 8'd0; b = 8'd0;
            #1;

            check_outputs(1'b0, 8'd0);
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
        input expected_overflow;
        input [7:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, s=%h",
                         overflow, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, s=%h",
                         expected_overflow, expected_s);
                $display("  Got:      overflow=%b, s=%h",
                         overflow, s);
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
