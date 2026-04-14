`timescale 1ns/1ps

module wallace_tree_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    wire [4:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wallace_tree_adder dut (
        .a(a),
        .b(b),
        .c(c),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 4'd0;
            b = 4'd0;
            c = 4'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 4'd1;
            b = 4'd2;
            c = 4'd3;
            #1;

            check_outputs(5'd6);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 4'd15;
            b = 4'd0;
            c = 4'd0;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 4'd4;
            b = 4'd4;
            c = 4'd4;
            #1;

            check_outputs(5'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 4'd7;
            b = 4'd8;
            c = 4'd5;
            #1;

            check_outputs(5'd20);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 4'd15;
            b = 4'd10;
            c = 4'd6;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 4'd15;
            b = 4'd15;
            c = 4'd15;
            #1;

            check_outputs(5'd13);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 4'b1010;
            b = 4'b0101;
            c = 4'b1010;
            #1;

            check_outputs(5'd25);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wallace_tree_adder Testbench");
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
        input [4:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
