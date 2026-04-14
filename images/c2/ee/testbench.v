`timescale 1ns/1ps

module multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Multiplication (0 * 0)", test_num);
        a = 8'd0;
        b = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiply by Zero (255 * 0)", test_num);
        a = 8'd255;
        b = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiply by One (128 * 1)", test_num);
        a = 8'd128;
        b = 8'd1;
        #1;

        check_outputs(16'd128);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small Values (12 * 10)", test_num);
        a = 8'd12;
        b = 8'd10;
        #1;

        check_outputs(16'd120);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Values (255 * 255)", test_num);
        a = 8'hFF;
        b = 8'hFF;
        #1;

        check_outputs(16'hFE01);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Prime Multiplication (13 * 17)", test_num);
        a = 8'd13;
        b = 8'd17;
        #1;

        check_outputs(16'd221);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-range Values (123 * 45)", test_num);
        a = 8'd123;
        b = 8'd45;
        #1;

        check_outputs(16'd5535);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power of Two (64 * 4)", test_num);
        a = 8'd64;
        b = 8'd4;
        #1;

        check_outputs(16'd256);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier Testbench");
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
        input [15:0] expected_result;
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
