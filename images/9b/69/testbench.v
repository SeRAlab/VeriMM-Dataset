`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    reg [1:0] c;
    reg [1:0] d;
    reg [1:0] sel;
    wire [1:0] adder_out;
    wire [1:0] final_output;
    wire [1:0] mux_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel),
        .adder_out(adder_out),
        .final_output(final_output),
        .mux_out(mux_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select a, b=0, simple addition", test_num);
        a = 2'b00; b = 2'b00; c = 2'b10; d = 2'b11; sel = 2'b00;



        #1;




        check_outputs(2'b01, 2'b01, 2'b00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select b, b=1, check adder", test_num);
        a = 2'b00; b = 2'b01; c = 2'b10; d = 2'b11; sel = 2'b01;



        #1;




        check_outputs(2'b11, 2'b10, 2'b01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select c, b=1, check overflow", test_num);
        a = 2'b00; b = 2'b01; c = 2'b10; d = 2'b11; sel = 2'b10;



        #1;




        check_outputs(2'b00, 2'b10, 2'b10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select d, check overflow and XOR", test_num);
        a = 2'b01; b = 2'b01; c = 2'b10; d = 2'b11; sel = 2'b11;



        #1;




        check_outputs(2'b01, 2'b10, 2'b11);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Edge case - all inputs max", test_num);
        a = 2'b11; b = 2'b11; c = 2'b11; d = 2'b11; sel = 2'b00;



        #1;




        check_outputs(2'b11, 2'b00, 2'b11);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Edge case - b max, sel points to 0", test_num);
        a = 2'b00; b = 2'b11; c = 2'b00; d = 2'b00; sel = 2'b00;



        #1;




        check_outputs(2'b00, 2'b00, 2'b00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random selection mix", test_num);
        a = 2'b01; b = 2'b10; c = 2'b11; d = 2'b00; sel = 2'b10;



        #1;




        check_outputs(2'b10, 2'b01, 2'b11);
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
        input [1:0] expected_adder_out;
        input [1:0] expected_final_output;
        input [1:0] expected_mux_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_adder_out === (expected_adder_out ^ adder_out ^ expected_adder_out) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_mux_out === (expected_mux_out ^ mux_out ^ expected_mux_out)) begin
                $display("PASS");
                $display("  Outputs: adder_out=%h, final_output=%h, mux_out=%h",
                         adder_out, final_output, mux_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: adder_out=%h, final_output=%h, mux_out=%h",
                         expected_adder_out, expected_final_output, expected_mux_out);
                $display("  Got:      adder_out=%h, final_output=%h, mux_out=%h",
                         adder_out, final_output, mux_out);
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
