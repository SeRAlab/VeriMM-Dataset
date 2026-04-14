`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Cin;
    reg [15:0] W;
    reg [15:0] X;
    reg [15:0] Y;
    reg [15:0] Z;
    wire [15:0] C;
    wire Ovfl;
    wire [15:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Cin(Cin),
        .W(W),
        .X(X),
        .Y(Y),
        .Z(Z),
        .C(C),
        .Ovfl(Ovfl),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            W = 16'h0000; X = 16'h0000; Y = 16'h0000; Z = 16'h0000; Cin = 1'b0;
            $display("Test %0d: All Zeros", test_num);
            #1;

            check_outputs(16'h0000, 1'b0, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            W = 16'h0001; X = 16'h0001; Y = 16'h0001; Z = 16'h0001; Cin = 1'b0;
            $display("Test %0d: Single bit addition (1+1+1+1)", test_num);


            #1;



            check_outputs(16'h0001, 1'b0, 16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            W = 16'h0000; X = 16'h0000; Y = 16'h0000; Z = 16'h0000; Cin = 1'b1;
            $display("Test %0d: Carry-in only", test_num);
            #1;

            check_outputs(16'h0000, 1'b0, 16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            W = 16'hFFFF; X = 16'hFFFF; Y = 16'hFFFF; Z = 16'hFFFF; Cin = 1'b1;
            $display("Test %0d: Maximum values with Cin", test_num);
            #1;

            check_outputs(16'hFFFF, 1'b1, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            W = 16'h3333; X = 16'h3333; Y = 16'h3333; Z = 16'h3333; Cin = 1'b0;
            $display("Test %0d: Pattern 3333 addition", test_num);

            #1;


            check_outputs(16'h3333, 1'b0, 16'h6666);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            W = 16'h5555; X = 16'h5555; Y = 16'h5555; Z = 16'h5555; Cin = 1'b0;
            $display("Test %0d: Pattern 5555 addition", test_num);
            #1;

            check_outputs(16'h5555, 1'b0, 16'hAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            W = 16'h8000; X = 16'h8000; Y = 16'h8000; Z = 16'h8000; Cin = 1'b0;
            $display("Test %0d: MSB Overflow", test_num);

            #1;


            check_outputs(16'h8000, 1'b1, 16'h0000);
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
        input [15:0] expected_C;
        input expected_Ovfl;
        input [15:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_Ovfl === (expected_Ovfl ^ Ovfl ^ expected_Ovfl) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C=%h, Ovfl=%b, S=%h",
                         C, Ovfl, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, Ovfl=%b, S=%h",
                         expected_C, expected_Ovfl, expected_S);
                $display("  Got:      C=%h, Ovfl=%b, S=%h",
                         C, Ovfl, S);
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
