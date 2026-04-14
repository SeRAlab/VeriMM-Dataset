`timescale 1ns/1ps

module and_logic_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg reset;
    wire [3:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    and_logic dut (
        .A(A),
        .B(B),
        .reset(reset),
        .C(C)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Reset then AND(F, 0)", test_num);
            reset = 1;
            A = 4'hF;
            B = 4'hF;
            #10;
            reset = 0;
            A = 4'hF;
            B = 4'h0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Reset then AND(F, F)", test_num);
            reset = 1;
            #10;
            reset = 0;
            A = 4'hF;
            B = 4'hF;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Reset then AND(A, C)", test_num);
            reset = 1;
            #10;
            reset = 0;
            A = 4'hA;
            B = 4'hC;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Reset then AND(5, 3)", test_num);
            reset = 1;
            #10;
            reset = 0;
            A = 4'h5;
            B = 4'h3;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Reset then AND(D, B)", test_num);
            reset = 1;
            #10;
            reset = 0;
            A = 4'hD;
            B = 4'hB;
            #1;

            check_outputs(4'h9);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Reset then AND(A, 5)", test_num);
            reset = 1;
            #10;
            reset = 0;
            A = 4'hA;
            B = 4'h5;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Reset then AND(0, 0)", test_num);
            reset = 1;
            #10;
            reset = 0;
            A = 4'h0;
            B = 4'h0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Verification of active reset override", test_num);
            reset = 1;
            A = 4'hF;
            B = 4'hF;
            #10;

            #1;


            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("and_logic Testbench");
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
        input [3:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
