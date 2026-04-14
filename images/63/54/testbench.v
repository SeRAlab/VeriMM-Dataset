`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    wire [3:0] c;
    wire cout;
    wire [3:0] g;
    wire [3:0] p;
    wire [3:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .c(c),
        .cout(cout),
        .g(g),
        .p(p),
        .s(s)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 4'b0000; b = 4'b0000; cin = 1'b0;

            #1;


            check_outputs(4'h0, 1'b0, 4'h0, 4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 4'b0000; b = 4'b0000; cin = 1'b1;

            #1;


            check_outputs(4'h1, 1'b0, 4'h0, 4'h0, 4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 4'hF; b = 4'h0; cin = 1'b0;

            #1;


            check_outputs(4'h0, 1'b0, 4'h0, 4'hF, 4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 4'hF; b = 4'h0; cin = 1'b1;

            #1;


            check_outputs(4'hF, 1'b1, 4'h0, 4'hF, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 4'hF; b = 4'hF; cin = 1'b1;

            #1;


            check_outputs(4'hF, 1'b1, 4'hF, 4'h0, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 4'h5; b = 4'hA; cin = 1'b0;

            #1;


            check_outputs(4'h0, 1'b0, 4'h0, 4'hF, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 4'h3; b = 4'h3; cin = 1'b0;

            #1;


            check_outputs(4'h6, 1'b0, 4'h3, 4'h0, 4'h6);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 4'h7; b = 4'h1; cin = 1'b0;

            #1;


            check_outputs(4'hE, 1'b0, 4'h1, 4'h6, 4'h8);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            a = 4'h8; b = 4'h8; cin = 1'b0;

            #1;


            check_outputs(4'h0, 1'b1, 4'h8, 4'h0, 4'h0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            a = 4'hA; b = 4'h6; cin = 1'b0;

            #1;


            check_outputs(4'hC, 1'b1, 4'h2, 4'hC, 4'h0);
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
        input [3:0] expected_c;
        input expected_cout;
        input [3:0] expected_g;
        input [3:0] expected_p;
        input [3:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c === (expected_c ^ c ^ expected_c) &&
                expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_p === (expected_p ^ p ^ expected_p) &&
                expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: c=%h, cout=%b, g=%h, p=%h, s=%h",
                         c, cout, g, p, s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c=%h, cout=%b, g=%h, p=%h, s=%h",
                         expected_c, expected_cout, expected_g, expected_p, expected_s);
                $display("  Got:      c=%h, cout=%b, g=%h, p=%h, s=%h",
                         c, cout, g, p, s);
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
