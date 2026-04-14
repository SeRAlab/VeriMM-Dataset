`timescale 1ns/1ps

module adder_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire carry_out;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_16bit dut (
        .a(a),
        .b(b),
        .carry_out(carry_out),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero addition", test_num);
            a = 16'h0000;
            b = 16'h0000;
            #1;

            check_outputs(1'b0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small positive addition", test_num);
            a = 16'h0005;
            b = 16'h000A;
            #1;

            check_outputs(1'b0, 16'h000F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum sum without carry", test_num);
            a = 16'hFFFF;
            b = 16'h0000;
            #1;

            check_outputs(1'b0, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimal carry-out trigger", test_num);
            a = 16'hFFFF;
            b = 16'h0001;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum possible sum with carry", test_num);
            a = 16'hFFFF;
            b = 16'hFFFF;
            #1;

            check_outputs(1'b1, 16'hFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range value addition", test_num);
            a = 16'h1234;
            b = 16'h5678;
            #1;

            check_outputs(1'b0, 16'h68AC);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Bit propagation across nibbles", test_num);
            a = 16'h0FFF;
            b = 16'h0001;
            #1;

            check_outputs(1'b0, 16'h1000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits (0xAAAA + 0x5555)", test_num);
            a = 16'hAAAA;
            b = 16'h5555;
            #1;

            check_outputs(1'b0, 16'hFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Most significant bit carry", test_num);
            a = 16'h8000;
            b = 16'h8000;
            #1;

            check_outputs(1'b1, 16'h0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large sum with carry", test_num);
            a = 16'hC000;
            b = 16'hC000;
            #1;

            check_outputs(1'b1, 16'h8000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_16bit Testbench");
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
        input expected_carry_out;
        input [15:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, sum=%h",
                         carry_out, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, sum=%h",
                         expected_carry_out, expected_sum);
                $display("  Got:      carry_out=%b, sum=%h",
                         carry_out, sum);
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
