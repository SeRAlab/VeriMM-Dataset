`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg c_in;
    reg [1:0] g;
    reg [1:0] p;
    wire c_out;
    wire g_out;
    wire p_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c_in(c_in),
        .g(g),
        .p(p),
        .c_out(c_out),
        .g_out(g_out),
        .p_out(p_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All inputs zero", test_num);
        g = 2'b00; p = 2'b00; c_in = 1'b0;



        #1;




        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Carry propagate through both bits", test_num);
        g = 2'b00; p = 2'b11; c_in = 1'b1;



        #1;




        check_outputs(1'b1, 1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit 0 generates, propagates through bit 1", test_num);
        g = 2'b01; p = 2'b10; c_in = 1'b0;



        #1;




        check_outputs(1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit 1 generates", test_num);
        g = 2'b10; p = 2'b00; c_in = 1'b0;



        #1;




        check_outputs(1'b1, 1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Carry in high but no propagate", test_num);
        g = 2'b00; p = 2'b00; c_in = 1'b1;



        #1;




        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit 0 propagate only", test_num);
        g = 2'b00; p = 2'b01; c_in = 1'b1;





        #1;






        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit 1 propagate only", test_num);
        g = 2'b00; p = 2'b10; c_in = 1'b1;





        #1;






        check_outputs(1'b0, 1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum propagation and generation", test_num);
        g = 2'b11; p = 2'b11; c_in = 1'b1;



        #1;




        check_outputs(1'b1, 1'b1, 1'b1);
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
        input expected_c_out;
        input expected_g_out;
        input expected_p_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c_out === (expected_c_out ^ c_out ^ expected_c_out) &&
                expected_g_out === (expected_g_out ^ g_out ^ expected_g_out) &&
                expected_p_out === (expected_p_out ^ p_out ^ expected_p_out)) begin
                $display("PASS");
                $display("  Outputs: c_out=%b, g_out=%b, p_out=%b",
                         c_out, g_out, p_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_out=%b, g_out=%b, p_out=%b",
                         expected_c_out, expected_g_out, expected_p_out);
                $display("  Got:      c_out=%b, g_out=%b, p_out=%b",
                         c_out, g_out, p_out);
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
