`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg RE;
    reg WE;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .D(D),
        .RE(RE),
        .WE(WE),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        RE = 0;
        forever #5 RE = ~RE;
    end

        task reset_dut;

        begin
            D = 0;
            WE = 0;

            @(negedge RE);
            WE = 1;
            D = 0;
            @(negedge RE);
            WE = 0;
            @(negedge RE);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write 1, Read 1", test_num);
            reset_dut();
            @(negedge RE);
            D = 1;
            WE = 1;
            @(negedge RE);
            WE = 0;
            @(posedge RE);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write 0, Read 0", test_num);
            reset_dut();
            @(negedge RE);
            D = 1; WE = 1;
            @(negedge RE);
            D = 0; WE = 1;
            @(negedge RE);
            WE = 0;
            @(posedge RE);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: WE Gating (Write 1 with WE=0)", test_num);
            reset_dut();
            @(negedge RE);
            D = 1;
            WE = 0;
            @(negedge RE);
            @(posedge RE);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Retention", test_num);
            reset_dut();
            @(negedge RE);
            D = 1; WE = 1;
            @(negedge RE);
            WE = 0; D = 0;
            repeat (3) @(negedge RE);
            @(posedge RE);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Update (1 to 0)", test_num);
            reset_dut();
            @(negedge RE);
            D = 1; WE = 1;
            @(negedge RE);
            D = 0; WE = 1;
            @(negedge RE);
            WE = 0;
            @(posedge RE);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simultaneous Read/Write", test_num);
            reset_dut();
            @(negedge RE);
            D = 1;
            WE = 1;

            @(posedge RE);
            #1;
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
        $display("eeprom_cell Testbench");
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
        $dumpvars(0,D, RE, WE, Q);
    end

endmodule
