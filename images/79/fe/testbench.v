`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg Cin;
    wire Cout;
    wire [31:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 32'h00000000;
            B = 32'h00000000;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 32'h00000000;
            B = 32'h00000000;
            Cin = 1'b1;
            #1;

            check_outputs(1'b0, 32'h00000001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 32'h12345678;
            B = 32'h87654321;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 32'h99999999);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 32'hFFFFFFFF;
            B = 32'h00000000;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 32'hFFFFFFFF;
            B = 32'h00000000;
            Cin = 1'b1;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;
            Cin = 1'b0;
            #1;

            check_outputs(1'b1, 32'hFFFFFFFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 32'hFFFFFFFF;
            B = 32'hFFFFFFFF;
            Cin = 1'b1;
            #1;

            check_outputs(1'b1, 32'hFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 32'hAAAAAAAA;
            B = 32'h55555555;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 32'hFFFFFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 32'hAAAAAAAA;
            B = 32'h55555555;
            Cin = 1'b1;
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 32'h0000FFFF;
            B = 32'h00000001;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 32'h00010000);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            A = 32'h7FFFFFFF;
            B = 32'h00000001;
            Cin = 1'b0;
            #1;

            check_outputs(1'b0, 32'h80000000);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            A = 32'h80000000;
            B = 32'h80000000;
            Cin = 1'b0;
            #1;

            check_outputs(1'b1, 32'h00000000);
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
        testcase011();
        testcase012();
        
        
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
        input expected_Cout;
        input [31:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, S=%h",
                         Cout, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, S=%h",
                         expected_Cout, expected_S);
                $display("  Got:      Cout=%b, S=%h",
                         Cout, S);
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
