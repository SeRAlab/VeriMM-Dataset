`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [3:0] ina;
    reg [3:0] inb;
    wire cout;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .ina(ina),
        .inb(inb),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 0 + 0 + cin=0", test_num);
        ina = 4'b0000; inb = 4'b0000; cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 5 + 3 + cin=0", test_num);
        ina = 4'd5; inb = 4'd3; cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: 5 + 3 + cin=1", test_num);
        ina = 4'd5; inb = 4'd3; cin = 1'b1;
        #1;

        check_outputs(1'b0, 4'd9);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max sum without cout (15 + 0 + 0)", test_num);
        ina = 4'hf; inb = 4'h0; cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'hf);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple cout (15 + 1 + 0)", test_num);
        ina = 4'hf; inb = 4'h1; cin = 1'b0;
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary cout (8 + 8 + 0)", test_num);
        ina = 4'h8; inb = 4'h8; cin = 1'b0;
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max inputs with cin (15 + 15 + 1)", test_num);
        ina = 4'hf; inb = 4'hf; cin = 1'b1;
        #1;

        check_outputs(1'b1, 4'hf);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Result 16 with cin (10 + 5 + 1)", test_num);
        ina = 4'ha; inb = 4'h5; cin = 1'b1;
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bits (10 + 5 + 0)", test_num);
        ina = 4'b1010; inb = 4'b0101; cin = 1'b0;
        #1;

        check_outputs(1'b0, 4'b1111);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Mid-range with cin (7 + 4 + 1)", test_num);
        ina = 4'd7; inb = 4'd4; cin = 1'b1;
        #1;

        check_outputs(1'b0, 4'd12);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
