`timescale 1ns/1ps

module bitwise_check_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] vec;
    wire [2:0] result_left;
    wire [2:0] result_right;
    wire [3:0] result_xor;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_check dut (
        .vec(vec),
        .result_left(result_left),
        .result_right(result_right),
        .result_xor(result_xor)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            vec = 4'b0000;
            #1;

            check_outputs(3'b000, 3'b000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All ones", test_num);
            vec = 4'b1111;
            #1;

            check_outputs(3'b111, 3'b111, 4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating 1010", test_num);
            vec = 4'b1010;
            #1;

            check_outputs(3'b000, 3'b111, 4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Continuous block 0110", test_num);
            vec = 4'b0110;
            #1;

            check_outputs(3'b010, 3'b111, 4'b0101);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Wrapping bits 1001", test_num);
            vec = 4'b1001;
            #1;

            check_outputs(3'b000, 3'b101, 4'b0101);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit 0001", test_num);
            vec = 4'b0001;
            #1;

            check_outputs(3'b000, 3'b001, 4'b1001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: High bits 1100", test_num);
            vec = 4'b1100;
            #1;

            check_outputs(3'b100, 3'b110, 4'b1010);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed 0111", test_num);
            vec = 4'b0111;
            #1;

            check_outputs(3'b011, 3'b111, 4'b1100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_check Testbench");
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
        input [2:0] expected_result_left;
        input [2:0] expected_result_right;
        input [3:0] expected_result_xor;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result_left === (expected_result_left ^ result_left ^ expected_result_left) &&
                expected_result_right === (expected_result_right ^ result_right ^ expected_result_right) &&
                expected_result_xor === (expected_result_xor ^ result_xor ^ expected_result_xor)) begin
                $display("PASS");
                $display("  Outputs: result_left=%h, result_right=%h, result_xor=%h",
                         result_left, result_right, result_xor);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result_left=%h, result_right=%h, result_xor=%h",
                         expected_result_left, expected_result_right, expected_result_xor);
                $display("  Got:      result_left=%h, result_right=%h, result_xor=%h",
                         result_left, result_right, result_xor);
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
