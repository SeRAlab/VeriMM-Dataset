`timescale 1ns/1ps

module adder_5bit_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    reg [4:0] b;
    wire overflow;
    wire [5:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_5bit dut (
        .a(a),
        .b(b),
        .overflow(overflow),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 5'd0; b = 5'd0;
        $display("Test %0d: 0 + 0", test_num);
        #1;

        check_outputs(1'b0, 6'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 5'd5; b = 5'd10;
        $display("Test %0d: 5 + 10", test_num);
        #1;

        check_outputs(1'b0, 6'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 5'd15; b = 5'd16;
        $display("Test %0d: 15 + 16 (Sum = 31, no overflow boundary)", test_num);
        #1;

        check_outputs(1'b0, 6'd31);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 5'd16; b = 5'd16;
        $display("Test %0d: 16 + 16 (Sum = 32, overflow boundary)", test_num);
        #1;

        check_outputs(1'b1, 6'd32);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 5'd31; b = 5'd1;
        $display("Test %0d: 31 + 1 (Overflow)", test_num);
        #1;

        check_outputs(1'b1, 6'd32);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 5'd31; b = 5'd31;
        $display("Test %0d: 31 + 31 (Max values, max overflow)", test_num);
        #1;

        check_outputs(1'b1, 6'd62);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 5'd0; b = 5'd31;
        $display("Test %0d: 0 + 31", test_num);
        #1;

        check_outputs(1'b0, 6'd31);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 5'd20; b = 5'd25;
        $display("Test %0d: 20 + 25 (Random overflow case)", test_num);
        #1;

        check_outputs(1'b1, 6'd45);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 5'd1; b = 5'd1;
        $display("Test %0d: 1 + 1", test_num);
        #1;

        check_outputs(1'b0, 6'd2);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 5'd21; b = 5'd10;
        $display("Test %0d: 21 + 10 (Max sum without overflow)", test_num);
        #1;

        check_outputs(1'b0, 6'd31);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_5bit Testbench");
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
        input expected_overflow;
        input [5:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: overflow=%b, sum=%h",
                         overflow, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: overflow=%b, sum=%h",
                         expected_overflow, expected_sum);
                $display("  Got:      overflow=%b, sum=%h",
                         overflow, sum);
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
