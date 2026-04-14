`timescale 1ns/1ps

module bitwise_and_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] and_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_and dut (
        .a(a),
        .b(b),
        .and_result(and_result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            a = 4'b0000;
            b = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            a = 4'b1111;
            b = 4'b1111;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: No Overlapping Bits (Alternating)", test_num);
            a = 4'b1010;
            b = 4'b0101;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Prompt Example (0110 AND 1010)", test_num);
            a = 4'b0110;
            b = 4'b1010;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Match (LSB)", test_num);
            a = 4'b0001;
            b = 4'b1111;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Match (MSB)", test_num);
            a = 4'b1000;
            b = 4'b1111;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern", test_num);
            a = 4'b1101;
            b = 4'b1011;
            #1;

            check_outputs(4'b1001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_and Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [3:0] expected_and_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_and_result === (expected_and_result ^ and_result ^ expected_and_result)) begin
                $display("PASS");
                $display("  Outputs: and_result=%h",
                         and_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_result=%h",
                         expected_and_result);
                $display("  Got:      and_result=%h",
                         and_result);
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
