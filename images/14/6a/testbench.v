`timescale 1ns/1ps

module wallace_tree_adder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    reg [4:0] b;
    reg [4:0] c;
    wire [6:0] sum;

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
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros", test_num);
            a = 5'd0;
            b = 5'd0;
            c = 5'd0;
            #1;

            check_outputs(7'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All maximum values (31+31+31)", test_num);
            a = 5'd31;
            b = 5'd31;
            c = 5'd31;
            #1;

            check_outputs(7'd93);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single input non-zero", test_num);
            a = 5'd31;
            b = 5'd0;
            c = 5'd0;
            #1;

            check_outputs(7'd31);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Smallest non-zero values", test_num);
            a = 5'd1;
            b = 5'd1;
            c = 5'd1;
            #1;

            check_outputs(7'd3);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Powers of two", test_num);
            a = 5'd16;
            b = 5'd8;
            c = 5'd4;
            #1;

            check_outputs(7'd28);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Carry generation (15+15+1)", test_num);
            a = 5'd15;
            b = 5'd15;
            c = 5'd1;
            #1;

            check_outputs(7'd31);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed values", test_num);
            a = 5'd10;
            b = 5'd20;
            c = 5'd5;
            #1;

            check_outputs(7'd35);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating bits", test_num);
            a = 5'b10101;
            b = 5'b01010;
            c = 5'b00000;
            #1;

            check_outputs(7'd31);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large values nearing limit", test_num);
            a = 5'd25;
            b = 5'd25;
            c = 5'd25;
            #1;

            check_outputs(7'd75);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Random distribution", test_num);
            a = 5'd13;
            b = 5'd27;
            c = 5'd9;
            #1;

            check_outputs(7'd49);
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
        input [6:0] expected_sum;
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
