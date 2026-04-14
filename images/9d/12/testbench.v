`timescale 1ns/1ps

module adder_32bit_tb;

    // Testbench signals (combinational circuit)
    reg Cin;
    reg [31:0] a;
    reg [31:0] b;
    wire Cout;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_32bit dut (
        .Cin(Cin),
        .a(a),
        .b(b),
        .Cout(Cout),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero addition", test_num);
            a = 32'h00000000;
            b = 32'h00000000;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small numbers without carry", test_num);
            a = 32'h00000010;
            b = 32'h00000020;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 32'h00000030);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small numbers with Carry-in", test_num);
            a = 32'h00000005;
            b = 32'h00000005;
            Cin = 1'b1;
            #1;

            check_outputs(1'b0, 32'h0000000B);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry between 16-bit blocks (Low to High)", test_num);
            a = 32'h0000FFFF;
            b = 32'h00000001;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 32'h00010000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum value without Carry-out", test_num);
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum value with Carry-out (All 1s)", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h00000000;
            Cin = 1'b1;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overflow boundary", test_num);
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;
            Cin = 1'b0;
            #1;

            check_outputs(1'b1, 32'hFFFFFFFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits with carry", test_num);
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            Cin = 1'b1;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random pattern", test_num);
            a = 32'h12345678;
            b = 32'h87654321;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 32'h99999999);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large sum with carry-out", test_num);
            a = 32'h80000000;
            b = 32'h80000000;
            Cin = 1'b0;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_32bit Testbench");
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
        input expected_Cout;
        input [31:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, sum=%h",
                         Cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, sum=%h",
                         expected_Cout, expected_sum);
                $display("  Got:      Cout=%b, sum=%h",
                         Cout, sum);
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
