`timescale 1ns/1ps

module TLATNTSCAX2TS_tb;

    // Testbench signals (sequential circuit)
    reg CK;
    reg E;
    reg SE;
    wire ECK;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    TLATNTSCAX2TS dut (
        .CK(CK),
        .E(E),
        .SE(SE),
        .ECK(ECK)
    );

    // Clock generation (10ns period)
    initial begin
        CK = 0;
        forever #5 CK = ~CK;
    end

        task reset_dut;

        begin
            E = 0;
            SE = 0;
            @(negedge CK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            E = 0;
            SE = 0;

            @(posedge CK);
            #2;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            E = 1;
            SE = 0;

            @(posedge CK);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            E = 0;
            SE = 1;

            @(posedge CK);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            E = 1;
            SE = 0;
            @(posedge CK);
            #2;


            E = 0;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            E = 1;
            SE = 1;
            @(posedge CK);
            #2;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            E = 0; SE = 0;
            @(posedge CK);
            #2;

            E = 1;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();

            E = 1;
            @(negedge CK);
            #1;
            @(posedge CK);
            #2;
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
        input expected_ECK;
        begin
            if (expected_ECK === (expected_ECK ^ ECK ^ expected_ECK)) begin
                $display("PASS");
                $display("  Outputs: ECK=%b",
                         ECK);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ECK=%b",
                         expected_ECK);
                $display("  Got:      ECK=%b",
                         ECK);
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
        $dumpvars(0,CK, E, SE, ECK);
    end

endmodule
