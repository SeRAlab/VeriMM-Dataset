`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] O;
    reg [2:0] S;
    reg [2:0] U;
    reg [2:0] V;
    reg [2:0] W;
    reg [2:0] X;
    reg [2:0] Y;
    wire [23:0] M;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .O(O),
        .S(S),
        .U(U),
        .V(V),
        .W(W),
        .X(X),
        .Y(Y),
        .M(M)
    );
    task testcase001;

    begin
        test_num = 1;
        U = 3'b001; V = 3'b010; W = 3'b011; X = 3'b100; Y = 3'b101; O = 3'b110;
        S = 3'd0;
        #1;

        check_outputs({8{3'b001}});
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        U = 3'b001; V = 3'b010; W = 3'b011; X = 3'b100; Y = 3'b101; O = 3'b110;
        S = 3'd1;
        #1;

        check_outputs({8{3'b010}});
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        U = 3'b001; V = 3'b010; W = 3'b011; X = 3'b100; Y = 3'b101; O = 3'b110;
        S = 3'd2;
        #1;

        check_outputs({8{3'b011}});
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        U = 3'b001; V = 3'b010; W = 3'b011; X = 3'b100; Y = 3'b101; O = 3'b110;
        S = 3'd3;
        #1;

        check_outputs({8{3'b100}});
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        U = 3'b001; V = 3'b010; W = 3'b011; X = 3'b100; Y = 3'b101; O = 3'b110;
        S = 3'd4;
        #1;

        check_outputs({8{3'b101}});
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        U = 3'b001; V = 3'b010; W = 3'b011; X = 3'b100; Y = 3'b101; O = 3'b110;
        S = 3'd5;
        #1;

        check_outputs({8{3'b110}});
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        U = 3'd0; V = 3'd0; W = 3'd0; X = 3'd0; Y = 3'd0; O = 3'd0;
        S = 3'd2;
        #1;

        check_outputs(24'h000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        U = 3'd1; V = 3'd2; W = 3'd3; X = 3'd4; Y = 3'd5; O = 3'd7;
        S = 3'd7;
        #1;

        check_outputs({8{3'd7}});
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
        input [23:0] expected_M;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_M === (expected_M ^ M ^ expected_M)) begin
                $display("PASS");
                $display("  Outputs: M=%h",
                         M);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: M=%h",
                         expected_M);
                $display("  Got:      M=%h",
                         M);
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
