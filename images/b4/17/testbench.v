`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg cin;
    reg [2:0] in_vec;
    wire cout;
    wire [4:0] final_output;
    wire o0;
    wire o1;
    wire o2;
    wire [2:0] out_vec;
    wire sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .in_vec(in_vec),
        .cout(cout),
        .final_output(final_output),
        .o0(o0),
        .o1(o1),
        .o2(o2),
        .out_vec(out_vec),
        .sum(sum)
    );
    task run_check;

        reg e_sum;
        reg e_cout;
        reg [4:0] e_final;
        begin
            e_sum  = a ^ b ^ cin;
            e_cout = (a & b) | (b & cin) | (a & cin);

            e_final[0] = e_sum;
            e_final[1] = in_vec[1] | in_vec[0];
            e_final[2] = in_vec[2] | in_vec[1];
            e_final[3] = in_vec[1] & in_vec[0];
            e_final[4] = in_vec[2] & in_vec[1];

            #1;


            check_outputs(e_cout, e_final, in_vec[0], in_vec[1], in_vec[2], in_vec, e_sum);
        end
        endtask

    task testcase001;

    begin
        $display("Testcase 001: All zeros");
        test_num = 1;
        in_vec = 3'b000; a = 0; b = 0; cin = 0;
        run_check();
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: All ones");
        test_num = 2;
        in_vec = 3'b111; a = 1; b = 1; cin = 1;
        run_check();
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Full Adder Carry Generation (1+1+0)");
        test_num = 3;
        in_vec = 3'b101; a = 1; b = 1; cin = 0;
        run_check();
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Vector pattern 010, Sum 1+0+0");
        test_num = 4;
        in_vec = 3'b010; a = 1; b = 0; cin = 0;
        run_check();
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Vector pattern 110, Sum 0+1+1");
        test_num = 5;
        in_vec = 3'b110; a = 0; b = 1; cin = 1;
        run_check();
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Vector pattern 011, Mixed FA");
        test_num = 6;
        in_vec = 3'b011; a = 1; b = 0; cin = 1;
        run_check();
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Vector pattern 100, MSB only");
        test_num = 7;
        in_vec = 3'b100; a = 0; b = 0; cin = 1;
        run_check();
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Vector pattern 001, LSB only");
        test_num = 8;
        in_vec = 3'b001; a = 0; b = 1; cin = 0;
        run_check();
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
        input [4:0] expected_final_output;
        input expected_o0;
        input expected_o1;
        input expected_o2;
        input [2:0] expected_out_vec;
        input expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_final_output === (expected_final_output ^ final_output ^ expected_final_output) &&
                expected_o0 === (expected_o0 ^ o0 ^ expected_o0) &&
                expected_o1 === (expected_o1 ^ o1 ^ expected_o1) &&
                expected_o2 === (expected_o2 ^ o2 ^ expected_o2) &&
                expected_out_vec === (expected_out_vec ^ out_vec ^ expected_out_vec) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, final_output=%h, o0=%b, o1=%b, o2=%b, out_vec=%h, sum=%b",
                         cout, final_output, o0, o1, o2, out_vec, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, final_output=%h, o0=%b, o1=%b, o2=%b, out_vec=%h, sum=%b",
                         expected_cout, expected_final_output, expected_o0, expected_o1, expected_o2, expected_out_vec, expected_sum);
                $display("  Got:      cout=%b, final_output=%h, o0=%b, o1=%b, o2=%b, out_vec=%h, sum=%b",
                         cout, final_output, o0, o1, o2, out_vec, sum);
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
