`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg cin;
    reg [3:0] in;
    wire cout;
    wire lut4_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .in(in),
        .cout(cout),
        .lut4_out(lut4_out)
    );
    task testcase001;

        begin
            $display("Testcase 001: All inputs zero");
            in = 4'b0000; cin = 1'b0;
            #10;
            #1;

            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Carry-in only");
            in = 4'b0000; cin = 1'b1;
            #10;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Single bit set in 'in'");
            in = 4'b1000; cin = 1'b0; #10;
            #1;

            check_outputs(1'b0, 1'b1);

            in = 4'b0100; cin = 1'b0; #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: All inputs high");
            in = 4'b1111; cin = 1'b1;
            #10;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Carry generation via Propagate and Cin");
            in = 4'b1000; cin = 1'b1;
            #10;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        reg [1:0] exp;
        begin
            $display("Testcase 006: Exhaustive check (All 32 combinations)");
            for (i = 0; i < 32; i = i + 1) begin
                {in, cin} = i[4:0];
                #10;
                exp = expected_logic(in, cin);
                #1;

                check_outputs(exp[1], exp[0]);
            end
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
        input expected_lut4_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_lut4_out === (expected_lut4_out ^ lut4_out ^ expected_lut4_out)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, lut4_out=%b",
                         cout, lut4_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, lut4_out=%b",
                         expected_cout, expected_lut4_out);
                $display("  Got:      cout=%b, lut4_out=%b",
                         cout, lut4_out);
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
