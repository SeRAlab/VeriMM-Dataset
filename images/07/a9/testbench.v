`timescale 1ns/1ps

module multiplier_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_4bit dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'd0; B = 4'd0;
            $write("Testcase 001: A=0, B=0... ");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'd15; B = 4'd15;
            $write("Testcase 002: A=15, B=15... ");
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'd0; B = 4'd15;
            $write("Testcase 003: A=0, B=15... ");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'd12; B = 4'd0;
            $write("Testcase 004: A=12, B=0... ");
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'd1; B = 4'd1;
            $write("Testcase 005: A=1, B=1... ");
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'd3; B = 4'd7;
            $write("Testcase 006: A=3, B=7... ");
            #1;

            check_outputs(8'd21);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'd8; B = 4'd4;
            $write("Testcase 007: A=8, B=4... ");
            #1;

            check_outputs(8'd32);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'd13; B = 4'd11;
            $write("Testcase 008: A=13, B=11... ");
            #1;

            check_outputs(8'd143);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 4'b1010; B = 4'b0101;
            $write("Testcase 009: A=10, B=5... ");
            #1;

            check_outputs(8'd50);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 4'd14; B = 4'd15;
            $write("Testcase 010: A=14, B=15... ");
            #1;

            check_outputs(8'd210);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_4bit Testbench");
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
        input [7:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
