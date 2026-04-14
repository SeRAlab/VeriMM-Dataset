`timescale 1ns/1ps

module interrupt_controller_tb;

    // Testbench signals (sequential circuit)
    reg ack;
    reg enable;
    reg high_int;
    reg reg_int;
    wire interrupt_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    interrupt_controller dut (
        .ack(ack),
        .enable(enable),
        .high_int(high_int),
        .reg_int(reg_int),
        .interrupt_out(interrupt_out)
    );

    // Clock generation (10ns period)
    initial begin
        ack = 0;
        forever #5 ack = ~ack;
    end

        task reset_dut;

        begin
            enable = 0;
            reg_int = 0;
            high_int = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: All interrupts inactive, enable high");
            enable = 1;
            reg_int = 0;
            high_int = 0;
            #10;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Regular interrupt active and enabled");
            enable = 1;
            reg_int = 1;
            high_int = 0;
            #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: High-priority interrupt active and enabled");
            enable = 1;
            reg_int = 0;
            high_int = 1;
            #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Regular interrupt active but disabled");
            enable = 0;
            reg_int = 1;
            high_int = 0;
            #10;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: High-priority interrupt active but disabled");
            enable = 0;
            reg_int = 0;
            high_int = 1;
            #10;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase 006: Both interrupts active and enabled");
            enable = 1;
            reg_int = 1;
            high_int = 1;
            #10;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Testcase 007: Toggle enable with active interrupt");
            reg_int = 1;
            enable = 0;
            #10;
            enable = 1;
            #10;
            #1;

            check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("interrupt_controller Testbench");
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
        input expected_interrupt_out;
        begin
            if (expected_interrupt_out === (expected_interrupt_out ^ interrupt_out ^ expected_interrupt_out)) begin
                $display("PASS");
                $display("  Outputs: interrupt_out=%b",
                         interrupt_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: interrupt_out=%b",
                         expected_interrupt_out);
                $display("  Got:      interrupt_out=%b",
                         interrupt_out);
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
        $dumpvars(0,ack, enable, high_int, reg_int, interrupt_out);
    end

endmodule
