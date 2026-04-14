`timescale 1ns/1ps

module brent_kung_adder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] a;
    reg [4:0] b;
    reg cin;
    wire cout;
    wire [5:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    brent_kung_adder dut (
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero addition", test_num);
        a = 5'b00000; b = 5'b00000; cin = 1'b0;
        #1;

        check_outputs(1'b0, 6'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic addition without carry-in", test_num);
        a = 5'd10; b = 5'd5; cin = 1'b0;
        #1;

        check_outputs(1'b0, 6'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic addition with carry-in", test_num);
        a = 5'd10; b = 5'd5; cin = 1'b1;
        #1;

        check_outputs(1'b0, 6'd16);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum values with carry-in (All ones)", test_num);
        a = 5'b11111; b = 5'b11111; cin = 1'b1;
        #1;

        check_outputs(1'b1, 6'd63);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Result resulting in power of 2 (32)", test_num);
        a = 5'd16; b = 5'd16; cin = 1'b0;
        #1;

        check_outputs(1'b1, 6'd32);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Checkerboard pattern", test_num);
        a = 5'b10101; b = 5'b01010; cin = 1'b0;
        #1;

        check_outputs(1'b0, 6'd31);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Single bit carry propagation", test_num);
        a = 5'b11111; b = 5'b00000; cin = 1'b1;
        #1;

        check_outputs(1'b1, 6'd32);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large values without carry-out", test_num);
        a = 5'd15; b = 5'd15; cin = 1'b1;
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
        $display("brent_kung_adder Testbench");
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
        input [5:0] expected_sum;
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
