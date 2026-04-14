`timescale 1ns/1ps

module comparator_3bit_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    reg [2:0] B;
    reg [2:0] C;
    wire z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_3bit dut (
        .A(A),
        .B(B),
        .C(C),
        .z(z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 3'd3; B = 3'd1; C = 3'd5;
            $display("Test %0d: A=%d, B=%d, C=%d (Expected z=1)", test_num, A, B, C);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 3'd2; B = 3'd2; C = 3'd4;
            $display("Test %0d: A=%d, B=%d, C=%d (Expected z=1, A=B)", test_num, A, B, C);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 3'd4; B = 3'd2; C = 3'd4;
            $display("Test %0d: A=%d, B=%d, C=%d (Expected z=1, A=C)", test_num, A, B, C);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 3'd7; B = 3'd7; C = 3'd7;
            $display("Test %0d: A=%d, B=%d, C=%d (Expected z=1, A=B=C=max)", test_num, A, B, C);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 3'd1; B = 3'd2; C = 3'd4;
            $display("Test %0d: A=%d, B=%d, C=%d (Expected z=0, A < B)", test_num, A, B, C);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 3'd5; B = 3'd2; C = 3'd4;
            $display("Test %0d: A=%d, B=%d, C=%d (Expected z=0, A > C)", test_num, A, B, C);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 3'd3; B = 3'd5; C = 3'd2;
            $display("Test %0d: A=%d, B=%d, C=%d (Expected z=0, B > C range invalid)", test_num, A, B, C);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 3'd0; B = 3'd0; C = 3'd7;
            $display("Test %0d: A=%d, B=%d, C=%d (Expected z=1, min boundary)", test_num, A, B, C);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 3'd7; B = 3'd0; C = 3'd7;
            $display("Test %0d: A=%d, B=%d, C=%d (Expected z=1, max boundary)", test_num, A, B, C);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 3'd0; B = 3'd1; C = 3'd7;
            $display("Test %0d: A=%d, B=%d, C=%d (Expected z=0, edge case)", test_num, A, B, C);
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_3bit Testbench");
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
        input expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%b",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%b",
                         expected_z);
                $display("  Got:      z=%b",
                         z);
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
