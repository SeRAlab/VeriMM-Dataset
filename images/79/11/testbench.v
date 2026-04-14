`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
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
        .ctrl(ctrl),
        .c(c)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Unsigned 0 * 0", test_num);
            a = 8'd0;
            b = 8'd0;
            ctrl = 1'b0;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Unsigned 255 * 255", test_num);
            a = 8'hFF;
            b = 8'hFF;
            ctrl = 1'b0;
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Unsigned 123 * 45", test_num);
            a = 8'd123;
            b = 8'd45;
            ctrl = 1'b0;
            #1;

            check_outputs(16'd5535);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed 10 * 12", test_num);
            a = 8'd10;
            b = 8'd12;
            ctrl = 1'b1;
            #1;

            check_outputs(16'd120);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed -5 * 20", test_num);
            a = -8'd5;
            b = 8'd20;
            ctrl = 1'b1;
            #1;

            check_outputs(-16'd100);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed 15 * -4", test_num);
            a = 8'd15;
            b = -8'd4;
            ctrl = 1'b1;
            #1;

            check_outputs(-16'd60);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed -10 * -10", test_num);
            a = -8'd10;
            b = -8'd10;
            ctrl = 1'b1;
            #1;

            check_outputs(16'd100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed -128 * 127", test_num);
            a = 8'h80;
            b = 8'h7F;
            ctrl = 1'b1;
            #1;

            check_outputs(16'hC080);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Signed -128 * -128", test_num);
            a = 8'h80;
            b = 8'h80;
            ctrl = 1'b1;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Control switch (0xFF * 0xFF)", test_num);
            a = 8'hFF;
            b = 8'hFF;


            ctrl = 1'b0;
            #1;
            if (c !== 16'hFE01) begin
                $display("FAIL: Unsigned mode incorrect");
                fail_count = fail_count + 1;
            end else begin

                ctrl = 1'b1;
                #1;

                check_outputs(16'h0001);
            end
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
            #1; // Small delay for combinational logic to settle
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

endmodule
