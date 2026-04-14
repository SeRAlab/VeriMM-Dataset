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
        test_num = 1;
        a = 5'd0; b = 5'd0; c = 5'd0;
        $display("Test Case %03d: All Zeros", test_num);
        #1;

        check_outputs(7'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 5'd1; b = 5'd1; c = 5'd1;
        $display("Test Case %03d: Smallest values", test_num);
        #1;

        check_outputs(7'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 5'd31; b = 5'd31; c = 5'd31;
        $display("Test Case %03d: Maximum 5-bit values", test_num);
        #1;

        check_outputs(7'd93);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 5'd15; b = 5'd10; c = 5'd5;
        $display("Test Case %03d: Random distribution 1", test_num);
        #1;

        check_outputs(7'd30);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 5'd16; b = 5'd8; c = 5'd4;
        $display("Test Case %03d: Power of two bits", test_num);
        #1;

        check_outputs(7'd28);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 5'd31; b = 5'd0; c = 5'd0;
        $display("Test Case %03d: Single input active", test_num);
        #1;

        check_outputs(7'd31);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 5'd21; b = 5'd11; c = 5'd31;
        $display("Test Case %03d: Random distribution 2", test_num);
        #1;

        check_outputs(7'd63);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 5'd10; b = 5'd20; c = 5'd30;
        $display("Test Case %03d: Random distribution 3", test_num);
        #1;

        check_outputs(7'd60);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 5'd7; b = 5'd14; c = 5'd28;
        $display("Test Case %03d: Multiples of 7", test_num);
        #1;

        check_outputs(7'd49);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 5'd1; b = 5'd2; c = 5'd4;
        $display("Test Case %03d: Binary sequence", test_num);
        #1;

        check_outputs(7'd7);
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
