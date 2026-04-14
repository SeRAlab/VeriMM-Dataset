`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] input1;
    reg [15:0] input2;
    wire carry_output;
    wire [15:0] final_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input1(input1),
        .input2(input2),
        .carry_output(carry_output),
        .final_output(final_output)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Zero addition (0 + 0)", test_num);
        input1 = 16'h0000;
        input2 = 16'h0000;
        #1;

        check_outputs(1'b0, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Maximum value plus one (0xFFFF + 0x0001)", test_num);
        input1 = 16'hFFFF;
        input2 = 16'h0001;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Maximum values (0xFFFF + 0xFFFF)", test_num);
        input1 = 16'hFFFF;
        input2 = 16'hFFFF;
        #1;

        check_outputs(1'b1, 16'hFFFE);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Alternate bit pattern (0x5555 + 0xAAAA)", test_num);
        input1 = 16'h5555;
        input2 = 16'hAAAA;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Simple addition without carry (0x1234 + 0x4321)", test_num);
        input1 = 16'h1234;
        input2 = 16'h4321;
        #1;

        check_outputs(1'b0, 16'h5555);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Mid-point carry (0x00FF + 0x0001)", test_num);
        input1 = 16'h00FF;
        input2 = 16'h0001;
        #1;

        check_outputs(1'b0, 16'h0100);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: MSB addition carry (0x8000 + 0x8000)", test_num);
        input1 = 16'h8000;
        input2 = 16'h8000;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Complex addition (0xCAFE + 0xBEEF)", test_num);
        input1 = 16'hCAFE;
        input2 = 16'hBEEF;

        #1;


        check_outputs(1'b1, 16'h89ED);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Carry propagation through all bits (0xFFFF + 0x0000)", test_num);
        input1 = 16'hFFFF;
        input2 = 16'h0000;
        #1;

        check_outputs(1'b0, 16'hFFFF);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Random values (0x1357 + 0x2468)", test_num);
        input1 = 16'h1357;
        input2 = 16'h2468;
        #1;

        check_outputs(1'b0, 16'h37BF);
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
        input expected_carry_output;
        input [15:0] expected_final_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_output === (expected_carry_output ^ carry_output ^ expected_carry_output) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output)) begin
                $display("PASS");
                $display("  Outputs: carry_output=%b, final_output=%h",
                         carry_output, final_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_output=%b, final_output=%h",
                         expected_carry_output, expected_final_output);
                $display("  Got:      carry_output=%b, final_output=%h",
                         carry_output, final_output);
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
