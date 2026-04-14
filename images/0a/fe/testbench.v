`timescale 1ns/1ps

module fixed_point_adder_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_point_adder dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Simple Integer Addition", test_num);
        a = 16'h0100;
        b = 16'h0200;
        #1;

        check_outputs(16'h0300);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Simple Fractional Addition", test_num);
        a = 16'h0040;
        b = 16'h0080;
        #1;

        check_outputs(16'h00C0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Carry from Fraction to Integer", test_num);
        a = 16'h00C0;
        b = 16'h0080;
        #1;

        check_outputs(16'h0140);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Large Number Addition", test_num);
        a = 16'h7F00;
        b = 16'h0A80;
        #1;

        check_outputs(16'h8980);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Addition with Zero", test_num);
        a = 16'h0000;
        b = 16'h0520;
        #1;

        check_outputs(16'h0520);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Minimum Step Addition", test_num);
        a = 16'h0001;
        b = 16'h0001;
        #1;

        check_outputs(16'h0002);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Overflow Wrap-around", test_num);
        a = 16'hFF00;
        b = 16'h0100;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Mixed Addition", test_num);
        a = 16'h0A20;
        b = 16'h0510;
        #1;

        check_outputs(16'h0F30);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_point_adder Testbench");
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
        input [15:0] expected_sum;
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
