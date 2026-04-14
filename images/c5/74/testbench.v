`timescale 1ns/1ps

module TLATNTSCAX2TS_tb;

    // Testbench signals (sequential circuit)
    reg CK;
    reg E;
    reg ECK;
    reg SE;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    TLATNTSCAX2TS dut (
        .CK(CK),
        .E(E),
        .ECK(ECK),
        .SE(SE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        ECK = 0;
        forever #5 ECK = ~ECK;
    end

        task reset_dut;

    begin
        CK = 0;
        E = 0;
        SE = 0;

        @(posedge ECK);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %03d: Transparent Mode (E=1, SE=0) - Follow CK=1", test_num);
        E = 1; SE = 0; CK = 1;
        #2;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %03d: Transparent Mode (E=1, SE=0) - Follow CK=0", test_num);
        E = 1; SE = 0; CK = 0;
        #2;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %03d: Set Mode (SE=1) - High on ECK edge", test_num);
        SE = 1; E = 0; CK = 0;
        @(posedge ECK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %03d: Latch Mode (E=0) - Capture CK=1", test_num);
        E = 0; SE = 0; CK = 1;
        @(posedge ECK);
        #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;

        E = 0; SE = 1;
        @(posedge ECK); #1;

        SE = 0; CK = 0;
        @(posedge ECK); #1;
        $display("Testcase %03d: Latch Mode (E=0) - Capture CK=0", test_num);
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %03d: Latch Mode (E=0) - Hold Value", test_num);

        E = 0; SE = 0; CK = 1;
        @(posedge ECK); #1;

        CK = 0;
        #5;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %03d: Priority - SE=1 over E=1", test_num);
        E = 1; SE = 1; CK = 0;
        @(posedge ECK); #1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("TLATNTSCAX2TS Testbench");
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,CK, E, ECK, SE, Q);
    end

endmodule
