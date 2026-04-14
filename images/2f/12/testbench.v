`timescale 1ns/1ps

module JK_FF_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR;
    reg J;
    reg K;
    wire Q;
    wire Qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    JK_FF dut (
        .CLK(CLK),
        .CLR(CLR),
        .J(J),
        .K(K),
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
            CLR = 1;
            J = 0;
            K = 0;
            @(negedge CLK);
            CLR = 0;
            @(negedge CLK);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Set - Q should go from 0 to 1", test_num);
            reset_dut();
            J = 1; K = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Reset - Q should stay/become 0", test_num);
            reset_dut();

            J = 1; K = 0;
            @(posedge CLK);

            @(negedge CLK);
            J = 0; K = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Hold - Q should remain 1", test_num);
            reset_dut();

            J = 1; K = 0;
            @(posedge CLK);

            @(negedge CLK);
            J = 0; K = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Toggle - Q should go from 0 to 1", test_num);
            reset_dut();
            J = 1; K = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Toggle - Q should go from 1 to 0", test_num);
            reset_dut();

            J = 1; K = 0;
            @(posedge CLK);

            @(negedge CLK);
            J = 1; K = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Continuous Toggle (2 clock cycles)", test_num);
            reset_dut();
            J = 1; K = 1;
            @(posedge CLK);
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: CLR priority - Q should reset even if J=1", test_num);
            reset_dut();

            J = 1; K = 0;
            @(posedge CLK);

            @(negedge CLK);
            CLR = 1;
            J = 1; K = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Hold at 0 after reset", test_num);
            reset_dut();
            J = 0; K = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("JK_FF Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,CLK, CLR, J, K, Q, Qn);
    end

endmodule
