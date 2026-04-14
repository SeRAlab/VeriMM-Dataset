`timescale 1ns/1ps

module flash_memory_cell_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg E;
    reg R;
    reg W;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_cell dut (
        .D(D),
        .E(E),
        .R(R),
        .W(W),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        E = 0;
        forever #5 E = ~E;
    end

        task reset_dut;

        begin
            D = 0;
            W = 0;
            R = 0;
            E = 1;
            #10;
            E = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write 1 then Read back", test_num);
            reset_dut();


            D = 1; W = 1; R = 0; E = 0;
            #10;
            W = 0;
            #10;


            R = 1;
            #10;
            #1;

            check_outputs(1'b1);
            R = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write 0 then Read back", test_num);
            reset_dut();


            D = 1; W = 1; #10;


            D = 0; W = 1; #10;
            W = 0;
            #10;


            R = 1;
            #10;
            #1;

            check_outputs(1'b0);
            R = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Erase stored data", test_num);
            reset_dut();


            D = 1; W = 1; #10;
            W = 0;


            E = 1;
            #10;
            E = 0;


            R = 1;
            #10;
            #1;

            check_outputs(1'b0);
            R = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Read disabled output check", test_num);
            reset_dut();


            D = 1; W = 1; #10;
            W = 0;


            R = 0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-operation sequence", test_num);
            reset_dut();


            D = 1; W = 1; #10; W = 0;

            D = 0; W = 1; #10; W = 0;

            D = 1; W = 1; #10; W = 0;


            R = 1;
            #10;
            #1;

            check_outputs(1'b1);
            R = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory_cell Testbench");
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
        $dumpvars(0,D, E, R, W, Q);
    end

endmodule
