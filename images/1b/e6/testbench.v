`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg enable;
    reg erase;
    reg rw;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .data_in(data_in),
        .enable(enable),
        .erase(erase),
        .rw(rw),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        enable = 0;
        forever #5 enable = ~enable;
    end

        task reset_dut;

        begin
            test_num = test_num + 1;
            erase = 1;
            rw = 0;
            data_in = 8'h00;
            @(posedge enable);
            #1;
            erase = 0;
            @(posedge enable);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Verify Erase/Default State (0xFF)");
            reset_dut();

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Write and Read (0xA5)");
            reset_dut();
            data_in = 8'hA5;
            rw = 1;
            erase = 0;
            @(posedge enable);
            #1;
            rw = 0;
            @(posedge enable);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Data Retention during Read");
            reset_dut();

            data_in = 8'h55;
            rw = 1;
            @(posedge enable);
            #1;

            rw = 0;
            data_in = 8'hFF;
            @(posedge enable);
            @(posedge enable);
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Erase after Write");
            reset_dut();

            data_in = 8'h12;
            rw = 1;
            @(posedge enable);
            #1;

            erase = 1;
            @(posedge enable);
            #1;
            erase = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwriting existing data");
            reset_dut();

            data_in = 8'hAA;
            rw = 1;
            @(posedge enable);
            #1;

            data_in = 8'hBB;
            rw = 1;
            @(posedge enable);
            #1;
            rw = 0;
            #1;

            check_outputs(8'hBB);
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,data_in, enable, erase, rw, data_out);
    end

endmodule
