`timescale 1ns/1ps

module bw_u1_zzmulcsa42_5x_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg cin;
    reg d;
    wire carry;
    wire cout;
    wire sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bw_u1_zzmulcsa42_5x dut (
        .a(a),
        .b(b),
        .c(c),
        .cin(cin),
        .d(d),
        .carry(carry),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs 0", test_num);
        a = 0; b = 0; c = 0; d = 0; cin = 0;
        #1;

        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All inputs 1", test_num);
        a = 1; b = 1; c = 1; d = 1; cin = 1;
        #1;

        check_outputs(1'b1, 1'b1, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a and c high (cout test)", test_num);
        a = 1; b = 0; c = 1; d = 0; cin = 0;
        #1;

        check_outputs(1'b0, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: cin and b high (carry test)", test_num);
        a = 0; b = 1; c = 0; d = 0; cin = 1;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: b and a high", test_num);
        a = 1; b = 1; c = 0; d = 0; cin = 0;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: c, d, cin high", test_num);
        a = 0; b = 0; c = 1; d = 1; cin = 1;
        #1;

        check_outputs(1'b1, 1'b1, 1'b1);


    end
        endtask

    task testcase006_fixed;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: c, d, cin high", test_num);
        a = 0; b = 0; c = 1; d = 1; cin = 1;
        #1;

        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a, c, d high", test_num);
        a = 1; b = 0; c = 1; d = 1; cin = 0;
        #1;

        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: a, b, cin high", test_num);
        a = 1; b = 1; c = 0; d = 0; cin = 1;
        #1;

        check_outputs(1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: b, a, c high", test_num);
        a = 1; b = 1; c = 1; d = 0; cin = 0;
        #1;

        check_outputs(1'b0, 1'b1, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: cin, d high", test_num);
        a = 0; b = 0; c = 0; d = 1; cin = 1;
        #1;

        check_outputs(1'b1, 1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bw_u1_zzmulcsa42_5x Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase006_fixed();
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
        input expected_carry;
        input expected_cout;
        input expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, cout=%b, sum=%b",
                         carry, cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, cout=%b, sum=%b",
                         expected_carry, expected_cout, expected_sum);
                $display("  Got:      carry=%b, cout=%b, sum=%b",
                         carry, cout, sum);
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
