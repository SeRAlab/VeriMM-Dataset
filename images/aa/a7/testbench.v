`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg [3:0] in;
    wire cout;
    wire [3:0] final_output;
    wire [1:0] pos;
    wire sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .in(in),
        .cout(cout),
        .final_output(final_output),
        .pos(pos),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Priority 3 (in=1000), Half Adder 0+0", test_num);
        in = 4'b1000; a = 0; b = 0;

        #1;


        check_outputs(1'b0, 4'b1000, 2'b11, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Priority 3 (in=1000), Half Adder 1+1", test_num);
        in = 4'b1000; a = 1; b = 1;

        #1;


        check_outputs(1'b1, 4'b1010, 2'b11, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Priority 2 (in=0100), Half Adder 1+1", test_num);
        in = 4'b0100; a = 1; b = 1;

        #1;


        check_outputs(1'b1, 4'b0001, 2'b10, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Priority 1 (in=0010), Half Adder 0+1", test_num);
        in = 4'b0010; a = 0; b = 1;

        #1;


        check_outputs(1'b0, 4'b0011, 2'b01, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Priority 0 (in=0001), Half Adder 1+1", test_num);
        in = 4'b0001; a = 1; b = 1;

        #1;


        check_outputs(1'b1, 4'b0001, 2'b00, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Priority Check (multiple bits), pos=3", test_num);
        in = 4'b1111; a = 0; b = 0;

        #1;


        check_outputs(1'b0, 4'b1111, 2'b11, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Addition Overflow Check (15 + 2)", test_num);
        in = 4'b1111; a = 1; b = 1;

        #1;


        check_outputs(1'b1, 4'b0001, 2'b11, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Carry Bit Selection (cout=0)", test_num);
        in = 4'b0110; a = 0; b = 1;

        #1;


        check_outputs(1'b0, 4'b0000, 2'b10, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Priority 1 with Half Adder sum and carry", test_num);
        in = 4'b0011; a = 1; b = 1;

        #1;


        check_outputs(1'b1, 4'b0101, 2'b01, 1'b0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Priority 3 with add sum only", test_num);
        in = 4'b1011; a = 0; b = 1;

        #1;


        check_outputs(1'b0, 4'b1100, 2'b11, 1'b1);
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
        input [3:0] expected_final_output;
        input [1:0] expected_pos;
        input expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_pos === (expected_pos ^ pos ^ expected_pos) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, final_output=%h, pos=%h, sum=%b",
                         cout, final_output, pos, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, final_output=%h, pos=%h, sum=%b",
                         expected_cout, expected_final_output, expected_pos, expected_sum);
                $display("  Got:      cout=%b, final_output=%h, pos=%h, sum=%b",
                         cout, final_output, pos, sum);
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
