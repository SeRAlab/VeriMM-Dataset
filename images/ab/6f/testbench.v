`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] a;
    reg [1:0] s;
    reg [9:0] x;
    reg [9:0] y;
    reg [9:0] z;
    wire [9:0] f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .s(s),
        .x(x),
        .y(y),
        .z(z),
        .f(f)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            x = 10'h3FF;
            y = 10'h000;
            z = 10'h000;
            a = 10'h000;
            s = 2'b00;
            #5;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            x = 10'h000;
            y = 10'h2AA;
            z = 10'h000;
            a = 10'h000;
            s = 2'b01;
            #5;
            #1;

            check_outputs(10'h2AA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            x = 10'h000;
            y = 10'h000;
            z = 10'h155;
            a = 10'h000;
            s = 2'b10;
            #5;
            #1;

            check_outputs(10'h155);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            x = 10'h000;
            y = 10'h000;
            z = 10'h000;
            a = 10'h001;
            s = 2'b11;
            #5;
            #1;

            check_outputs(10'h001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            x = 10'h123;
            y = 10'h234;
            z = 10'h345;
            a = 10'h000;
            s = 2'b00;
            #5;
            #1;

            check_outputs(10'h123);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            x = 10'h123;
            y = 10'h234;
            z = 10'h345;
            a = 10'h000;
            s = 2'b01;
            #5;
            #1;

            check_outputs(10'h234);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            x = 10'h123;
            y = 10'h234;
            z = 10'h345;
            a = 10'h000;
            s = 2'b10;
            #5;
            #1;

            check_outputs(10'h345);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            x = 10'h123;
            y = 10'h234;
            z = 10'h345;
            a = 10'h3FF;
            s = 2'b11;
            #5;
            #1;

            check_outputs(10'h3FF);
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
        input [9:0] expected_f;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_f === (expected_f ^ f ^ expected_f)) begin
                $display("PASS");
                $display("  Outputs: f=%h",
                         f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: f=%h",
                         expected_f);
                $display("  Got:      f=%h",
                         f);
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
