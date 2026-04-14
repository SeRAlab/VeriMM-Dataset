`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] N;
    reg [15:0] P;
    wire [15:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encrypt dut (
        .N(N),
        .P(P),
        .C(C)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: P=2, N=11 (2^3 mod 11 = 8)", test_num);
            P = 16'd2;
            N = 16'd11;
            #1;

            check_outputs(16'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: P=5, N=13 (125 mod 13 = 8)", test_num);
            P = 16'd5;
            N = 16'd13;
            #1;

            check_outputs(16'd8);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: P=10, N=17 (1000 mod 17 = 14)", test_num);
            P = 16'd10;
            N = 16'd17;
            #1;

            check_outputs(16'd14);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: P=3, N=20 (27 mod 20 = 7)", test_num);
            P = 16'd3;
            N = 16'd20;
            #1;

            check_outputs(16'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: P=1, N=100 (1^3 mod 100 = 1)", test_num);
            P = 16'd1;
            N = 16'd100;
            #1;

            check_outputs(16'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: P=0, N=50 (0^3 mod 50 = 0)", test_num);
            P = 16'd0;
            N = 16'd50;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: P=4, N=15 (64 mod 15 = 4)", test_num);
            P = 16'd4;
            N = 16'd15;
            #1;

            check_outputs(16'd4);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: P=10, N=1000 (1000 mod 1000 = 0)", test_num);
            P = 16'd10;
            N = 16'd1000;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Large P, Small N: P=10, N=7 (1000 mod 7 = 6)", test_num);
            P = 16'd10;
            N = 16'd7;
            #1;

            check_outputs(16'd6);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: P=32, N=256 (32768 mod 256 = 0)", test_num);
            P = 16'd32;
            N = 16'd256;
            #1;

            check_outputs(16'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rsa_encrypt Testbench");
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
        input [15:0] expected_C;
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
