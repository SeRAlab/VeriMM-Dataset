`timescale 1ns/1ps

module dff_posedge_reset_set_tb;

    // Testbench signals (sequential circuit)
    reg C;
    reg D;
    reg reset;
    reg set;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dff_posedge_reset_set dut (
        .C(C),
        .D(D),
        .reset(reset),
        .set(set),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        C = 0;
        forever #5 C = ~C;
    end

        task reset_dut;

        begin
            reset = 1;
            set = 0;
            D = 0;
            #12;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Reset", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capture D=1 on Rising Edge", test_num);
            reset_dut();
            @(negedge C);
            D = 1;
            set = 0;
            @(posedge C);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capture D=0 on Rising Edge", test_num);
            reset_dut();

            @(negedge C); D = 1; @(posedge C); #1;

            @(negedge C); D = 0; @(posedge C); #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Set Priority (Set=1, D=0)", test_num);
            reset_dut();
            @(negedge C);
            D = 0;
            set = 1;
            @(posedge C);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Asynchronous Reset Priority", test_num);
            reset_dut();
            @(negedge C);
            D = 1;
            set = 1;
            @(posedge C);
            #1;
            reset = 1;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No Change on Falling Edge", test_num);
            reset_dut();
            @(posedge C); #1;
            D = 1;
            @(negedge C);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Persistence (No clock transition)", test_num);
            reset_dut();
            @(negedge C);
            D = 1;
            @(posedge C);
            #1;
            D = 0;
            set = 0;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Set sampled at edge", test_num);
            reset_dut();
            @(posedge C);
            #1;
            set = 1;
            #2;

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
        $display("dff_posedge_reset_set Testbench");
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
        $dumpvars(0,C, D, reset, set, Q);
    end

endmodule
