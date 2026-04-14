`timescale 1ns/1ps

module adder_4bit_tb;

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
    adder_4bit dut (
        .a(a),
        .b(b),
        .cin(cin),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition without carry-in", test_num);
            a = 4'h1; b = 4'h1; cin = 0;
            #1;

            check_outputs(1'b0, 4'h2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition with carry-in", test_num);
            a = 4'h2; b = 4'h3; cin = 1;
            #1;

            check_outputs(1'b0, 4'h6);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum sum without carry-out", test_num);
            a = 4'h7; b = 4'h8; cin = 0;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Generating carry-out (F + 1)", test_num);
            a = 4'hF; b = 4'h1; cin = 0;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones with carry-in", test_num);
            a = 4'hF; b = 4'hF; cin = 1;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero inputs", test_num);
            a = 4'h0; b = 4'h0; cin = 0;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry propagation (F + 0 + 1)", test_num);
            a = 4'hF; b = 4'h0; cin = 1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits", test_num);
            a = 4'hA; b = 4'h5; cin = 0;
            #1;

            check_outputs(1'b0, 4'hF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits with carry-in", test_num);
            a = 4'hA; b = 4'h5; cin = 1;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary condition carry-out", test_num);
            a = 4'h8; b = 4'h8; cin = 0;
            #1;

            check_outputs(1'b1, 4'h0);
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
