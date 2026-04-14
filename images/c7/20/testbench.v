`timescale 1ns/1ps

module adder_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [4:0] c;
    wire co;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_4bit dut (
        .a(a),
        .b(b),
        .c(c),
        .co(co)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Addition (0 + 0)", test_num);
            a = 4'd0;
            b = 4'd0;
            #1;

            check_outputs(5'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small Addition (2 + 3)", test_num);
            a = 4'd2;
            b = 4'd3;
            #1;

            check_outputs(5'd5, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max value without carry-out (15 + 0)", test_num);
            a = 4'd15;
            b = 4'd0;
            #1;

            check_outputs(5'd15, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum carry-out (8 + 8)", test_num);
            a = 4'd8;
            b = 4'd8;
            #1;

            check_outputs(5'd16, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary carry-out (15 + 1)", test_num);
            a = 4'd15;
            b = 4'd1;
            #1;

            check_outputs(5'd16, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum possible sum (15 + 15)", test_num);
            a = 4'd15;
            b = 4'd15;
            #1;

            check_outputs(5'd30, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits (10 + 5)", test_num);
            a = 4'b1010;
            b = 4'b0101;
            #1;

            check_outputs(5'd15, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry out with mid-range values (10 + 10)", test_num);
            a = 4'd10;
            b = 4'd10;
            #1;

            check_outputs(5'd20, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_4bit Testbench");
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
        input [4:0] expected_c;
        input expected_co;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_co === (expected_co ^ co ^ expected_co)) begin
                $display("PASS");
                $display("  Outputs: c=%h, co=%b",
                         c, co);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h, co=%b",
                         expected_c, expected_co);
                $display("  Got:      c=%h, co=%b",
                         c, co);
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
