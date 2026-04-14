`timescale 1ns/1ps

module SR_Latch_DFF_tb;

    // Testbench signals (sequential circuit)
    reg Enable;
    reg R;
    reg S;
    wire Q;
    wire Qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SR_Latch_DFF dut (
        .Enable(Enable),
        .R(R),
        .S(S),
        .Q(Q),
        .Qn(Qn)
    );

    // Clock generation (10ns period)
    initial begin
        Enable = 0;
        forever #5 Enable = ~Enable;
    end

        task reset_dut;

        begin
            S = 0;
            R = 1;
            @(posedge Enable);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Set Operation (S=1, R=0)", test_num);
            reset_dut();


            @(negedge Enable);
            S = 1;
            R = 0;


            @(posedge Enable);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Operation (S=0, R=1)", test_num);
            reset_dut();


            @(negedge Enable);
            S = 0;
            R = 1;

            @(posedge Enable);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hold Operation after Set (S=0, R=0)", test_num);
            reset_dut();


            @(negedge Enable);
            S = 1; R = 0;
            @(posedge Enable);
            #2;


            @(negedge Enable);
            S = 0; R = 0;
            @(posedge Enable);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hold Operation after Reset (S=0, R=0)", test_num);
            reset_dut();


            @(negedge Enable);
            S = 0; R = 0;
            @(posedge Enable);
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Verify isolation between Enable pulses", test_num);
            reset_dut();


            @(negedge Enable);
            S = 1; R = 0;


            #1;
            if (Q === 0) begin
                $display("  Sub-test: Logic correctly isolated before Enable edge.");
            end


            @(posedge Enable);
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SR_Latch_DFF Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        $dumpvars(0,Enable, R, S, Q, Qn);
    end

endmodule
