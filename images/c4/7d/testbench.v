`timescale 1ns/1ps

module sky130_fd_sc_hdll__o32ai_tb;

    // Testbench signals (combinational circuit)
    reg A1;
    reg A2;
    reg A3;
    reg B1;
    reg B2;
    reg VGND;
    reg VNB;
    reg VPB;
    reg VPWR;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sky130_fd_sc_hdll__o32ai dut (
        .A1(A1),
        .A2(A2),
        .A3(A3),
        .B1(B1),
        .B2(B2),
        .VGND(VGND),
        .VNB(VNB),
        .VPB(VPB),
        .VPWR(VPWR),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("Testcase 001: Condition for Y=1 (A=000, B=11)");
            A1 = 0; A2 = 0; A3 = 0; B1 = 1; B2 = 1;
            VGND = 0; VNB = 0; VPB = 1; VPWR = 1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: A1 high (A=100, B=11)");
            A1 = 1; A2 = 0; A3 = 0; B1 = 1; B2 = 1;
            VGND = 0; VNB = 0; VPB = 1; VPWR = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: A2 high (A=010, B=11)");
            A1 = 0; A2 = 1; A3 = 0; B1 = 1; B2 = 1;
            VGND = 0; VNB = 0; VPB = 1; VPWR = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: A3 high (A=001, B=11)");
            A1 = 0; A2 = 0; A3 = 1; B1 = 1; B2 = 1;
            VGND = 0; VNB = 0; VPB = 1; VPWR = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: B1 low (A=000, B=01)");
            A1 = 0; A2 = 0; A3 = 0; B1 = 0; B2 = 1;
            VGND = 0; VNB = 0; VPB = 1; VPWR = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: B2 low (A=000, B=10)");
            A1 = 0; A2 = 0; A3 = 0; B1 = 1; B2 = 0;
            VGND = 0; VNB = 0; VPB = 1; VPWR = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: All inputs high");
            A1 = 1; A2 = 1; A3 = 1; B1 = 1; B2 = 1;
            VGND = 0; VNB = 0; VPB = 1; VPWR = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: All inputs low");
            A1 = 0; A2 = 0; A3 = 0; B1 = 0; B2 = 0;
            VGND = 0; VNB = 0; VPB = 1; VPWR = 1;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Power pins toggled (Logic should remain same)");
            A1 = 0; A2 = 0; A3 = 0; B1 = 1; B2 = 1;
            VGND = 1; VNB = 1; VPB = 0; VPWR = 0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Randomized mix (A=101, B=10)");
            A1 = 1; A2 = 0; A3 = 1; B1 = 1; B2 = 0;
            VGND = 0; VNB = 0; VPB = 1; VPWR = 1;
            #10;
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
        $display("sky130_fd_sc_hdll__o32ai Testbench");
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
