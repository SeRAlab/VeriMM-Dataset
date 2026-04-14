`timescale 1ns/1ps

module ripple_carry_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    wire cout;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ripple_carry_adder dut (
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        a = 4'b0000; b = 4'b0000; cin = 0;
        $display("Test %0d: 0 + 0 + cin=0", test_num);
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = 4'b0011; b = 4'b0100; cin = 0;
        $display("Test %0d: 3 + 4 + cin=0", test_num);
        #1;

        check_outputs(1'b0, 4'b0111);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 4'b1111; b = 4'b0000; cin = 1;
        $display("Test %0d: 15 + 0 + cin=1 (Carry propagation)", test_num);
        #1;

        check_outputs(1'b1, 4'b0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = 4'b0101; b = 4'b0101; cin = 1;
        $display("Test %0d: 5 + 5 + cin=1", test_num);
        #1;

        check_outputs(1'b0, 4'b1011);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 4'b1000; b = 4'b1000; cin = 0;
        $display("Test %0d: 8 + 8 + cin=0 (MSB Carry)", test_num);
        #1;

        check_outputs(1'b1, 4'b0000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        a = 4'b0111; b = 4'b0001; cin = 0;
        $display("Test %0d: 7 + 1 + cin=0 (Internal Carries)", test_num);
        #1;

        check_outputs(1'b0, 4'b1000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        a = 4'b1111; b = 4'b1111; cin = 1;
        $display("Test %0d: 15 + 15 + cin=1 (Max value)", test_num);
        #1;

        check_outputs(1'b1, 4'b1111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        a = 4'b1010; b = 4'b0101; cin = 0;
        $display("Test %0d: Alternating bits 10 + 5", test_num);
        #1;

        check_outputs(1'b0, 4'b1111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ripple_carry_adder Testbench");
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
        input expected_cout;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%b, sum=%h",
                         cout, sum);
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
