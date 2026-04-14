`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg G;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .D(D),
        .G(G),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        G = 0;
        forever #5 G = ~G;
    end

        task reset_dut;

        begin
            D = 0;

            @(posedge G);
            D = 0;
            @(negedge G);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Writing 1 to cell and checking hold...");
            test_num = 1;
            reset_dut();

            @(posedge G);
            D = 1;
            @(negedge G);

            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Writing 0 to cell and checking hold...");
            test_num = 2;
            reset_dut();


            @(posedge G); D = 1;
            @(negedge G);


            @(posedge G); D = 0;
            @(negedge G);

            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verifying state hold when D changes (G=0)...");
            test_num = 3;
            reset_dut();


            @(posedge G); D = 1;
            @(negedge G);


            #2;
            D = 0;
            #2;
            D = 1;
            #2;
            D = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Successive writes (1 -> 0 -> 1)...");
            test_num = 4;
            reset_dut();

            @(posedge G); D = 1;
            @(negedge G);
            @(posedge G); D = 0;
            @(negedge G);
            @(posedge G); D = 1;
            @(negedge G);

            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Checking value latched at close of gate...");
            test_num = 5;
            reset_dut();

            @(posedge G);
            D = 1; #1;
            D = 0; #1;
            D = 1;
            @(negedge G);

            #5;
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
        $display("dram_cell Testbench");
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
        $dumpvars(0,D, G, Q);
    end

endmodule
