`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg Cin;
    reg [3:0] G;
    reg [3:0] P;
    wire [3:0] Carry;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Cin(Cin),
        .G(G),
        .P(P),
        .Carry(Carry)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros", test_num);
            Cin = 0; P = 4'b0000; G = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-in with no propagate", test_num);
            Cin = 1; P = 4'b0000; G = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full propagate chain with Cin", test_num);
            Cin = 1; P = 4'b1111; G = 4'b0000;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full propagate chain without Cin", test_num);
            Cin = 0; P = 4'b1111; G = 4'b0000;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All generate signals active", test_num);
            Cin = 0; P = 4'b0000; G = 4'b1111;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Generate at bit 0 propagates to the end", test_num);
            Cin = 0; P = 4'b1110; G = 4'b0001;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Intermediate generate at bit 1", test_num);
            Cin = 0; P = 4'b1100; G = 4'b0010;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Generate at bit 3 only", test_num);
            Cin = 1; P = 4'b0111; G = 4'b1000;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Discontinuous carry chain with Cin", test_num);
            Cin = 1; P = 4'b1011; G = 4'b0000;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed P and G signals", test_num);
            Cin = 0; P = 4'b0101; G = 4'b1010;





            #1;






            check_outputs(4'b1110);
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
        input [3:0] expected_Carry;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Carry === (expected_Carry ^ Carry ^ expected_Carry)) begin
                $display("PASS");
                $display("  Outputs: Carry=%h",
                         Carry);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Carry=%h",
                         expected_Carry);
                $display("  Got:      Carry=%h",
                         Carry);
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
