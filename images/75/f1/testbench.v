`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [99:0] a;
    reg [99:0] b;
    reg cin;
    reg [299:0] data_in;
    reg [1:0] select;
    wire cout;
    wire [199:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .data_in(data_in),
        .select(select),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple addition, select segment 0, no carries", test_num);
            a = 100'h1;
            b = 100'h2;
            cin = 1'b0;

            data_in = {100'hA, 100'hB, 100'hC};
            select = 2'b00;

            #1;


            check_outputs(1'b0, {100'hC, 100'h3});
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-in test, select segment 1", test_num);
            a = 100'h5;
            b = 100'h5;
            cin = 1'b1;
            data_in = {100'hA, 100'hB, 100'hC};
            select = 2'b01;

            #1;


            check_outputs(1'b0, {100'hB, 100'hB});
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select segment 2", test_num);
            a = 100'h10;
            b = 100'h20;
            cin = 1'b0;
            data_in = {100'hA, 100'hB, 100'hC};
            select = 2'b10;

            #1;


            check_outputs(1'b0, {100'hA, 100'h30});
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Internal carry from lower 100 bits to upper 100 bits", test_num);
            a = ALL_ONES;
            b = 100'h1;
            cin = 1'b0;
            data_in = {100'h0, 100'h0, 100'h50};
            select = 2'b00;

            #1;


            check_outputs(1'b0, {100'h51, 100'h0});
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-out from bit 200", test_num);
            a = ALL_ONES;
            b = 100'h1;
            cin = 1'b0;
            data_in = {100'h0, 100'h0, ALL_ONES};
            select = 2'b00;

            #1;


            check_outputs(1'b1, 200'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large addition with cin and selection 2", test_num);
            a = 100'hDEADBEEF;
            b = 100'h1;
            cin = 1'b1;
            data_in = {100'hCAFEBABE, 100'h0, 100'h0};
            select = 2'b10;


            #1;



            check_outputs(1'b0, {100'hCAFEBABE, 100'hDEADBF01});
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones maximum values test", test_num);
            a = ALL_ONES;
            b = ALL_ONES;
            cin = 1'b1;
            data_in = {ALL_ONES, ALL_ONES, ALL_ONES};
            select = 2'b00;


            #1;



            check_outputs(1'b1, {100'h0, ALL_ONES});
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero inputs test", test_num);
            a = 100'h0;
            b = 100'h0;
            cin = 1'b0;
            data_in = 300'h0;
            select = 2'b00;
            #1;

            check_outputs(1'b0, 200'h0);
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
        input [199:0] expected_sum;
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
