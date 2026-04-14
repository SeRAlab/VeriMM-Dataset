`timescale 1ns/1ps

module chacha_add_sub_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg control;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    chacha_add_sub dut (
        .a(a),
        .b(b),
        .control(control),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Addition (1 + 1)", test_num);
            a = 32'h00000001;
            b = 32'h00000001;
            control = 1'b0;
            #1;

            check_outputs(32'h00000002);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple Subtraction (10 - 5)", test_num);
            a = 32'h0000000A;
            b = 32'h00000005;
            control = 1'b1;
            #1;

            check_outputs(32'h00000005);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with Overflow (Wrap-around)", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h00000001;
            control = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction with Underflow (Wrap-around)", test_num);
            a = 32'h00000000;
            b = 32'h00000001;
            control = 1'b1;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large Value Addition", test_num);
            a = 32'h80000000;
            b = 32'h80000000;
            control = 1'b0;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtracting to Zero", test_num);
            a = 32'h12345678;
            b = 32'h12345678;
            control = 1'b1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max Value Addition", test_num);
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            control = 1'b0;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: ChaCha-like Constants Addition", test_num);
            a = 32'h61707865;
            b = 32'h3320646e;
            control = 1'b0;
            #1;

            check_outputs(32'h9490DCD3);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Subtraction Resulting in Large Value", test_num);
            a = 32'h00000005;
            b = 32'h0000000A;
            control = 1'b1;
            #1;

            check_outputs(32'hFFFFFFF6);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Complex Bit Pattern Addition", test_num);
            a = 32'hDEADBEEF;
            b = 32'hCAFEBABE;
            control = 1'b0;
            #1;

            check_outputs(32'hA9AC99AD);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("chacha_add_sub Testbench");
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
