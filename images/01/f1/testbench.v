`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg erase;
    reg re;
    reg we;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .data_in(data_in),
        .erase(erase),
        .re(re),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        erase = 0;
        forever #5 erase = ~erase;
    end

        task reset_dut;

        begin
            we = 0;
            re = 0;
            data_in = 8'h00;

            #10;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Basic Write and Read");
            reset_dut();


            @(posedge erase);
            we = 1;
            data_in = 8'hAA;
            @(posedge erase);
            we = 0;


            @(posedge erase);
            re = 1;
            @(posedge erase);

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Erase Operation");
            reset_dut();


            @(posedge erase);
            we = 1;
            data_in = 8'h55;
            @(posedge erase);
            we = 0;





            re = 1;
            #10;


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Write Enable (WE) Gate Check");
            reset_dut();


            @(posedge erase);
            we = 0;
            data_in = 8'hCC;
            @(posedge erase);


            re = 1;
            @(posedge erase);

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Read Enable (RE) Gate Check");
            reset_dut();


            @(posedge erase);
            we = 1;
            data_in = 8'h77;
            @(posedge erase);
            we = 0;


            re = 0;
            @(posedge erase);


            #1;



            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Data Overwrite Check");
            reset_dut();


            @(posedge erase);
            we = 1;
            data_in = 8'h11;
            @(posedge erase);


            data_in = 8'h22;
            @(posedge erase);
            we = 0;


            re = 1;
            @(posedge erase);

            #1;


            check_outputs(8'h22);
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
        $dumpvars(0,data_in, erase, re, we, data_out);
    end

endmodule
