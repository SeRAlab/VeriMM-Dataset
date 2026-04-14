`timescale 1ns/1ps

module fixed_point_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [8:0] sum;

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
        $display("Testcase %0d: Zero addition (0.0 + 0.0)", test_num);
        a = 8'h00;
        b = 8'h00;
        #1;

        check_outputs(9'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Small fractional addition (0.0625 + 0.0625)", test_num);
        a = 8'h01;
        b = 8'h01;
        #1;

        check_outputs(9'h002);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Integer addition (5.0 + 3.0)", test_num);
        a = 8'h50;
        b = 8'h30;
        #1;

        check_outputs(9'h080);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Mixed addition (1.5 + 2.25)", test_num);
        a = 8'h18;
        b = 8'h24;
        #1;

        check_outputs(9'h03C);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Max value without 9-bit overflow (7.5 + 8.0)", test_num);
        a = 8'h78;
        b = 8'h80;
        #1;

        check_outputs(9'h0F8);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Boundary check for 8-bit overflow (15.9375 + 0.0625)", test_num);
        a = 8'hFF;
        b = 8'h01;
        #1;

        check_outputs(9'h100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Maximum possible sum (15.9375 + 15.9375)", test_num);
        a = 8'hFF;
        b = 8'hFF;
        #1;

        check_outputs(9'h1FE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Random bit pattern addition", test_num);
        a = 8'hA5;
        b = 8'h5A;
        #1;

        check_outputs(9'h0FF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Result resulting in 1.0 (0.5 + 0.5)", test_num);
        a = 8'h08;
        b = 8'h08;
        #1;

        check_outputs(9'h010);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Overflow check (8.0 + 8.0)", test_num);
        a = 8'h80;
        b = 8'h80;
        #1;

        check_outputs(9'h100);
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
        input [8:0] expected_sum;
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
