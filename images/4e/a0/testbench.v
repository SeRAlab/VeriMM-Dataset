`timescale 1ns/1ps

module adder4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire cout;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder4bit dut (
        .a(a),
        .b(b),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: 0 + 0", test_num);
        a = 4'h0; b = 4'h0;
        #1;

        check_outputs(1'b0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: 1 + 1", test_num);
        a = 4'h1; b = 4'h1;
        #1;

        check_outputs(1'b0, 4'h2);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: 15 + 0 (Max input boundary)", test_num);
        a = 4'hF; b = 4'h0;
        #1;

        check_outputs(1'b0, 4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: 0 + 15 (Max input boundary)", test_num);
        a = 4'h0; b = 4'hF;
        #1;

        check_outputs(1'b0, 4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: 8 + 8 (Carry out transition)", test_num);
        a = 4'h8; b = 4'h8;
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: 15 + 1 (Carry out transition)", test_num);
        a = 4'hF; b = 4'h1;
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: 15 + 15 (Max sum with carry)", test_num);
        a = 4'hF; b = 4'hF;
        #1;

        check_outputs(1'b1, 4'hE);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: 7 + 9 (Carry out check)", test_num);
        a = 4'h7; b = 4'h9;
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: 10 + 10", test_num);
        a = 4'hA; b = 4'hA;
        #1;

        check_outputs(1'b1, 4'h4);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: 5 + 3 (Simple addition)", test_num);
        a = 4'h5; b = 4'h3;
        #1;

        check_outputs(1'b0, 4'h8);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder4bit Testbench");
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
