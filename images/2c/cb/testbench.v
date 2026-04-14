`timescale 1ns/1ps

module master_slave_d_latch_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg D;
    wire Q;
    wire Qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    master_slave_d_latch dut (
        .CLK(CLK),
        .D(D),
        .Q(Q),
        .Qn(Qn)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            D = 0;

            @(negedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Capture D=1 when CLK is high", test_num);
            reset_dut();

            @(posedge CLK);
            D = 1;
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Capture D=0 when CLK is high", test_num);
            reset_dut();

            @(posedge CLK);
            D = 1;
            #2;
            D = 0;
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hold value 1 when CLK goes low", test_num);
            reset_dut();

            @(posedge CLK);
            D = 1;
            #2;
            @(negedge CLK);
            D = 0;
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hold value 0 when CLK goes low", test_num);
            reset_dut();

            @(posedge CLK);
            D = 0;
            #2;
            @(negedge CLK);
            D = 1;
            #2;
            #1;

            check_outputs(0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiple data changes while CLK is high", test_num);
            reset_dut();

            @(posedge CLK);
            D = 1; #1;
            D = 0; #1;
            D = 1; #1;
            D = 0; #1;
            D = 1; #1;
            #1;

            check_outputs(1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Data change at falling edge", test_num);
            reset_dut();

            @(posedge CLK);
            D = 0;
            #2;
            D = 1;
            @(negedge CLK);
            #1;
            D = 0;
            #2;
            #1;

            check_outputs(1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("master_slave_d_latch Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input expected_Qn;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qn === (expected_Qn ^ Qn ^ expected_Qn)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Qn=%b",
                         Q, Qn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Qn=%b",
                         expected_Q, expected_Qn);
                $display("  Got:      Q=%b, Qn=%b",
                         Q, Qn);
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
        $dumpvars(0,CLK, D, Q, Qn);
    end

endmodule
