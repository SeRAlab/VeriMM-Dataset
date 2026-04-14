`timescale 1ns/1ps

module add_subtract_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg sel;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    add_subtract dut (
        .a(a),
        .b(b),
        .sel(sel),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition (5 + 10)", test_num);
            a = 8'd5;
            b = 8'd10;
            sel = 1'b0;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Subtraction (20 - 5)", test_num);
            a = 8'd20;
            b = 8'd5;
            sel = 1'b1;
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Overflow (250 + 10)", test_num);
            a = 8'd250;
            b = 8'd10;
            sel = 1'b0;
            #1;

            check_outputs(8'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction with Underflow (5 - 10)", test_num);
            a = 8'd5;
            b = 8'd10;
            sel = 1'b1;
            #1;

            check_outputs(8'd251);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zeros Addition", test_num);
            a = 8'd0;
            b = 8'd0;
            sel = 1'b0;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zeros Subtraction", test_num);
            a = 8'd0;
            b = 8'd0;
            sel = 1'b1;
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Values Addition (255 + 255)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            sel = 1'b0;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Values Subtraction (255 - 255)", test_num);
            a = 8'hFF;
            b = 8'hFF;
            sel = 1'b1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction Resulting in 1 (0 - 255)", test_num);
            a = 8'h00;
            b = 8'hFF;
            sel = 1'b1;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Input Subtraction (255 - 0)", test_num);
            a = 8'hFF;
            b = 8'h00;
            sel = 1'b1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("add_subtract Testbench");
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
