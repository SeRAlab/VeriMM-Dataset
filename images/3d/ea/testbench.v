`timescale 1ns/1ps

module JK_FF_tb;

    // Testbench signals (sequential circuit)
    reg J;
    reg K;
    reg PRESET;
    reg RESET;
    reg clock;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    JK_FF dut (
        .J(J),
        .K(K),
        .PRESET(PRESET),
        .RESET(RESET),
        .clock(clock),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        PRESET = 0;
        forever #5 PRESET = ~PRESET;
    end

        task reset_dut;

        begin
            RESET = 1;
            PRESET = 0;
            J = 0;
            K = 0;
            #15;
            RESET = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Asynchronous Reset", test_num);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Asynchronous Preset", test_num);
            PRESET = 1;
            #5;
            PRESET = 0;
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Synchronous Set (J=1, K=0)", test_num);
            @(posedge clock);
            J = 1;
            K = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();

            PRESET = 1; #5; PRESET = 0; #5;
            $display("Testcase %0d: Synchronous Reset (J=0, K=1)", test_num);
            @(posedge clock);
            J = 0;
            K = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();

            PRESET = 1; #5; PRESET = 0; #5;
            $display("Testcase %0d: Synchronous Hold (J=0, K=0)", test_num);
            @(posedge clock);
            J = 0;
            K = 0;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Synchronous Toggle (0->1)", test_num);
            @(posedge clock);
            J = 1;
            K = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();

            PRESET = 1; #5; PRESET = 0; #5;
            $display("Testcase %0d: Synchronous Toggle (1->0)", test_num);
            @(posedge clock);
            J = 1;
            K = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Async Reset Priority", test_num);
            @(posedge clock);
            J = 1;
            K = 0;
            RESET = 1;
            @(posedge clock);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Async Preset Priority", test_num);
            @(posedge clock);
            J = 0;
            K = 1;
            PRESET = 1;
            @(posedge clock);
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
        testcase009();
        
        
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
        $dumpvars(0,J, K, PRESET, RESET, clock, Q);
    end

endmodule
