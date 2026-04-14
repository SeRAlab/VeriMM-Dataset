`timescale 1ns/1ps

module encoder_8b10b_tb;

    // Testbench signals (sequential circuit)
    reg K;
    reg SBYTECLK;
    reg [7:0] ebi;
    reg reset;
    wire disparity;
    wire [9:0] tbi;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    encoder_8b10b dut (
        .K(K),
        .SBYTECLK(SBYTECLK),
        .ebi(ebi),
        .reset(reset),
        .disparity(disparity),
        .tbi(tbi)
    );

    // Clock generation (10ns period)
    initial begin
        SBYTECLK = 0;
        forever #5 SBYTECLK = ~SBYTECLK;
    end

        task reset_dut;

        begin
            SBYTECLK = 0;
            reset = 1;
            K = 0;
            ebi = 8'h00;
            @(posedge SBYTECLK);
            #2 reset = 0;
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: D0.0 Data Byte (RD-)", test_num);
            reset_dut();
            @(posedge SBYTECLK);
            ebi = 8'h00;
            K = 1'b0;
            @(posedge SBYTECLK);
            #2;
            #1;

            check_outputs(1'b1, 10'h274);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: K28.5 Control Character (RD-)", test_num);
            reset_dut();
            @(posedge SBYTECLK);
            ebi = 8'hbc;
            K = 1'b1;
            @(posedge SBYTECLK);
            #2;
            #1;

            check_outputs(1'b1, 10'h0FA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: D21.5 Neutral Data Byte", test_num);
            reset_dut();
            @(posedge SBYTECLK);
            ebi = 8'hb5;
            K = 1'b0;
            @(posedge SBYTECLK);
            #2;
            #1;

            check_outputs(1'b0, 10'h2AA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Disparity Flip (D0.0 -> D0.0)", test_num);
            reset_dut();
            @(posedge SBYTECLK);
            ebi = 8'h00; K = 1'b0;
            @(posedge SBYTECLK);
            ebi = 8'h00; K = 1'b0;
            @(posedge SBYTECLK);
            #2;
            #1;

            check_outputs(1'b0, 10'h18B);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Control Disparity Flip (K28.5 -> K28.5)", test_num);
            reset_dut();
            @(posedge SBYTECLK);
            ebi = 8'hbc; K = 1'b1;
            @(posedge SBYTECLK);
            ebi = 8'hbc; K = 1'b1;
            @(posedge SBYTECLK);
            #2;
            #1;

            check_outputs(1'b0, 10'h305);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: D10.2 Neutral Check", test_num);
            reset_dut();
            @(posedge SBYTECLK);
            ebi = 8'h4a;
            K = 1'b0;
            @(posedge SBYTECLK);
            #2;
            #1;

            check_outputs(1'b0, 10'h155);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: D31.7 Data Byte", test_num);
            reset_dut();
            @(posedge SBYTECLK);
            ebi = 8'hff;
            K = 1'b0;
            @(posedge SBYTECLK);
            #2;
            #1;

            check_outputs(1'b0, 10'h288);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("encoder_8b10b Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_disparity;
        input [9:0] expected_tbi;
        begin
            if (expected_disparity === (expected_disparity ^ disparity ^ expected_disparity) &&
                expected_tbi === (expected_tbi ^ tbi ^ expected_tbi)) begin
                $display("PASS");
                $display("  Outputs: disparity=%b, tbi=%h",
                         disparity, tbi);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: disparity=%b, tbi=%h",
                         expected_disparity, expected_tbi);
                $display("  Got:      disparity=%b, tbi=%h",
                         disparity, tbi);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,K, SBYTECLK, ebi, reset, disparity, tbi);
    end

endmodule
