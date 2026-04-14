`timescale 1ns/1ps

module bitwise_operations_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire [7:0] C;
    wire [7:0] D;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bitwise_operations dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 8'h00;
            B = 8'h00;
            $display("Testcase %0d: All Zeros (A=00, B=00)", test_num);
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 8'hFF;
            B = 8'hFF;
            $display("Testcase %0d: All Ones (A=FF, B=FF)", test_num);
            #1;

            check_outputs(8'hFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 8'hAA;
            B = 8'h55;
            $display("Testcase %0d: Alternating Bits (A=AA, B=55)", test_num);
            #1;

            check_outputs(8'h00, 8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 8'hF0;
            B = 8'h0F;
            $display("Testcase %0d: Nibble Swap (A=F0, B=0F)", test_num);
            #1;

            check_outputs(8'h00, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 8'hCC;
            B = 8'hC0;
            $display("Testcase %0d: Masking (A=CC, B=C0)", test_num);
            #1;

            check_outputs(8'hC0, 8'hCC);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 8'h81;
            B = 8'h7E;
            $display("Testcase %0d: Non-overlapping (A=81, B=7E)", test_num);
            #1;

            check_outputs(8'h00, 8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 8'h12;
            B = 8'h34;
            $display("Testcase %0d: Random Pattern 1 (A=12, B=34)", test_num);


            #1;



            check_outputs(8'h10, 8'h36);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 8'hA5;
            B = 8'hA5;
            $display("Testcase %0d: Identity (A=A5, B=A5)", test_num);
            #1;

            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bitwise_operations Testbench");
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
        input [7:0] expected_C;
        input [7:0] expected_D;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_D === (expected_D ^ D ^ expected_D)) begin
                $display("PASS");
                $display("  Outputs: C=%h, D=%h",
                         C, D);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, D=%h",
                         expected_C, expected_D);
                $display("  Got:      C=%h, D=%h",
                         C, D);
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
