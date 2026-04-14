`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] E;
    reg [7:0] P;
    wire [15:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encrypt dut (
        .E(E),
        .P(P),
        .C(C)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            P = 8'd0;
            E = 8'd5;
            $display("Testcase %0d: P=%d, E=%d (Expected C=0)", test_num, P, E);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            P = 8'd1;
            E = 8'd123;
            $display("Testcase %0d: P=%d, E=%d (Expected C=1)", test_num, P, E);
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            P = 8'd255;
            E = 8'd0;
            $display("Testcase %0d: P=%d, E=%d (Expected C=1)", test_num, P, E);
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            P = 8'd3;
            E = 8'd4;
            $display("Testcase %0d: P=%d, E=%d (Expected C=81)", test_num, P, E);
            #1;

            check_outputs(16'h0051);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            P = 8'd2;
            E = 8'd10;
            $display("Testcase %0d: P=%d, E=%d (Expected C=1024)", test_num, P, E);
            #1;

            check_outputs(16'h0400);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            P = 8'd255;
            E = 8'd1;
            $display("Testcase %0d: P=%d, E=%d (Expected C=255)", test_num, P, E);
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            P = 8'd255;
            E = 8'd2;
            $display("Testcase %0d: P=%d, E=%d (Expected C=65025)", test_num, P, E);
            #1;

            check_outputs(16'hFE01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            P = 8'd2;
            E = 8'd15;
            $display("Testcase %0d: P=%d, E=%d (Expected C=32768)", test_num, P, E);
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            P = 8'd2;
            E = 8'd17;
            $display("Testcase %0d: P=%d, E=%d (Expected C=65535)", test_num, P, E);
            #1;

            check_outputs(16'hFFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            P = 8'd10;
            E = 8'd3;
            $display("Testcase %0d: P=%d, E=%d (Expected C=1000)", test_num, P, E);
            #1;

            check_outputs(16'h03E8);
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
