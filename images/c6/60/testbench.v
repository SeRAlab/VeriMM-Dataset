`timescale 1ns/1ps

module multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [13:0] a;
    reg [15:0] b;
    reg clk;
    reg reset;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .result(result)
    );
    task reset_sequence;

        begin
            reset = 0;
            clk = 0;
            #20;
            reset = 1;
            #20;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero inputs", test_num);
            reset_sequence();
            a = 14'sd0;
            b = 16'd0;
            #1;

            check_outputs(32'sd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Positive a, Positive b", test_num);
            reset_sequence();
            a = 14'sd100;
            b = 16'd200;
            #1;

            check_outputs(32'sd20000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Negative a, Positive b", test_num);
            reset_sequence();
            a = -14'sd100;
            b = 16'd200;
            #1;

            check_outputs(-32'sd20000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum positive a, Maximum b", test_num);
            reset_sequence();
            a = 14'sh1FFF;
            b = 16'hFFFF;
            #1;

            check_outputs(32'sd536796185);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum negative a, Maximum b", test_num);
            reset_sequence();
            a = 14'sh2000;
            b = 16'hFFFF;
            #1;

            check_outputs(-32'sd536862720);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a is -1, b is max", test_num);
            reset_sequence();
            a = -14'sd1;
            b = 16'hFFFF;
            #1;

            check_outputs(-32'sd65535);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a is 0, b is max", test_num);
            reset_sequence();
            a = 14'sd0;
            b = 16'hFFFF;
            #1;

            check_outputs(32'sd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: a is max positive, b is 1", test_num);
            reset_sequence();
            a = 14'sh1FFF;
            b = 16'd1;
            #1;

            check_outputs(32'sd8191);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small negative a, small positive b", test_num);
            reset_sequence();
            a = -14'sd5;
            b = 16'd10;
            #1;

            check_outputs(-32'sd50);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large positive a, small positive b", test_num);
            reset_sequence();
            a = 14'sd4000;
            b = 16'd2;
            #1;

            check_outputs(32'sd8000);
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
        input [31:0] expected_result;
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
