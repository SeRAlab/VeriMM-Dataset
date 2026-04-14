`timescale 1ns/1ps

module or_gate_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    or_gate_4bit dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 4'b0000;
            b = 4'b0000;
            $display("Test Case %0d: All Zeros (a=%b, b=%b)", test_num, a, b);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 4'b1111;
            b = 4'b1111;
            $display("Test Case %0d: All Ones (a=%b, b=%b)", test_num, a, b);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 4'b1010;
            b = 4'b0101;
            $display("Test Case %0d: Alternating Bits (a=%b, b=%b)", test_num, a, b);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 4'b1100;
            b = 4'b0011;
            $display("Test Case %0d: Upper vs Lower Bits (a=%b, b=%b)", test_num, a, b);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 4'b1000;
            b = 4'b0001;
            $display("Test Case %0d: MSB and LSB (a=%b, b=%b)", test_num, a, b);
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 4'b0110;
            b = 4'b0010;
            $display("Test Case %0d: Overlapping Bits (a=%b, b=%b)", test_num, a, b);
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 4'b1111;
            b = 4'b0000;
            $display("Test Case %0d: All Ones OR All Zeros (a=%b, b=%b)", test_num, a, b);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 4'b0101;
            b = 4'b0000;
            $display("Test Case %0d: Identity Property (a=%b, b=%b)", test_num, a, b);
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            a = 4'b0011;
            b = 4'b0110;
            $display("Test Case %0d: Shifting Bits (a=%b, b=%b)", test_num, a, b);
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            a = 4'hE;
            b = 4'h7;
            $display("Test Case %0d: Hex Pattern (a=%h, b=%h)", test_num, a, b);
            #1;

            check_outputs(4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("or_gate_4bit Testbench");
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
        input [3:0] expected_result;
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
