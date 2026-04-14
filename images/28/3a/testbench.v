`timescale 1ns/1ps

module wallace_tree_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    wire [4:0] SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wallace_tree_adder dut (
        .A(A),
        .B(B),
        .C(C),
        .SUM(SUM)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs zero", test_num);
            A = 4'd0; B = 4'd0; C = 4'd0;
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single bit inputs (1+1+1)", test_num);
            A = 4'd1; B = 4'd1; C = 4'd1;
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single input max value", test_num);
            A = 4'd15; B = 4'd0; C = 4'd0;
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range values (5+10+2)", test_num);
            A = 4'd5; B = 4'd10; C = 4'd2;
            #1;

            check_outputs(5'd17);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Powers of two", test_num);
            A = 4'd8; B = 4'd4; C = 4'd2;
            #1;

            check_outputs(5'd14);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max value without 5-bit overflow (15+15+1)", test_num);
            A = 4'd15; B = 4'd15; C = 4'd1;
            #1;

            check_outputs(5'd31);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 5-bit Overflow Case (15+15+15=45 -> 13 mod 32)", test_num);

            A = 4'd15; B = 4'd15; C = 4'd15;
            #1;

            check_outputs(5'd13);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit patterns", test_num);
            A = 4'b1010;
            B = 4'b0101;
            C = 4'b1010;
            #1;

            check_outputs(5'd25);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary values (15+0+15)", test_num);
            A = 4'd15; B = 4'd0; C = 4'd15;
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small values (2+3+4)", test_num);
            A = 4'd2; B = 4'd3; C = 4'd4;
            #1;

            check_outputs(5'd9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wallace_tree_adder Testbench");
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
        input [4:0] expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: SUM=%h",
                         SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SUM=%h",
                         expected_SUM);
                $display("  Got:      SUM=%h",
                         SUM);
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
