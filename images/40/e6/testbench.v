`timescale 1ns/1ps

module rsa_encrypt_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [7:0] encrypted_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rsa_encrypt dut (
        .a(a),
        .b(b),
        .encrypted_out(encrypted_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=0, b=0 (Zero Case)", test_num);
            a = 8'd0;
            b = 8'd0;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=1, b=0 (Identity Base)", test_num);
            a = 8'd1;
            b = 8'd0;

            #1;


            check_outputs(8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=1, b=1 (Small Power)", test_num);
            a = 8'd1;
            b = 8'd1;

            #1;


            check_outputs(8'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=2, b=3 (Standard Message)", test_num);
            a = 8'd2;
            b = 8'd3;

            #1;


            check_outputs(8'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=3, b=4 (Standard Message)", test_num);
            a = 8'd3;
            b = 8'd4;

            #1;


            check_outputs(8'd13);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=10, b=0 (Message with power wrap)", test_num);
            a = 8'd10;
            b = 8'd0;

            #1;


            check_outputs(8'd10);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=25, b=30 (Message sum equals Modulus)", test_num);
            a = 8'd25;
            b = 8'd30;

            #1;


            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=40, b=14 (Message is n-1)", test_num);
            a = 8'd40;
            b = 8'd14;

            #1;


            check_outputs(8'd54);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=20, b=20 (Large Message sum)", test_num);
            a = 8'd20;
            b = 8'd20;

            #1;


            check_outputs(8'd35);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: a=255, b=255 (Max inputs)", test_num);
            a = 8'd255;
            b = 8'd255;


            #1;



            check_outputs(8'd20);
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
        input [7:0] expected_encrypted_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encrypted_out === (expected_encrypted_out ^ encrypted_out ^ expected_encrypted_out)) begin
                $display("PASS");
                $display("  Outputs: encrypted_out=%h",
                         encrypted_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encrypted_out=%h",
                         expected_encrypted_out);
                $display("  Got:      encrypted_out=%h",
                         encrypted_out);
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
