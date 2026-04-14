`timescale 1ns/1ps

module eeprom_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg [4:0] data_in;
    reg we;
    wire [4:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eeprom_cell dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .we(we),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 3'b0;
            data_in = 5'b0;
            we = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nTestcase 001: Basic Write and Read at Address 0");
            reset_dut();


            addr = 3'd0;
            data_in = 5'h1A;
            we = 1;
            @(posedge clk);


            we = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(5'h1A);
        end
        endtask

    task testcase002;

        begin
            $display("\nTestcase 002: Basic Write and Read at Address 7");
            reset_dut();


            addr = 3'd7;
            data_in = 5'h0F;
            we = 1;
            @(posedge clk);


            we = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(5'h0F);
        end
        endtask

    task testcase003;

        begin
            $display("\nTestcase 003: Verify Data Integrity across multiple addresses");
            reset_dut();


            addr = 3'd2; data_in = 5'h05; we = 1;
            @(posedge clk);


            addr = 3'd3; data_in = 5'h1E; we = 1;
            @(posedge clk);


            we = 0;
            addr = 3'd2;
            @(posedge clk);

            #1;
            #1;

            check_outputs(5'h05);
        end
        endtask

    task testcase004;

        begin
            $display("\nTestcase 004: Overwrite existing data");
            reset_dut();


            addr = 3'd4; data_in = 5'h11; we = 1;
            @(posedge clk);


            addr = 3'd4; data_in = 5'h02; we = 1;
            @(posedge clk);


            we = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(5'h02);
        end
        endtask

    task testcase005;

        begin
            $display("\nTestcase 005: Verify data is not written when WE is low");
            reset_dut();


            addr = 3'd1; data_in = 5'h0A; we = 1;
            @(posedge clk);


            addr = 3'd1; data_in = 5'h1F; we = 0;
            @(posedge clk);


            addr = 3'd1; we = 0;
            @(posedge clk);

            #1;
            #1;

            check_outputs(5'h0A);
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
        input [4:0] expected_data_out;
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
        $dumpvars(0,addr, clk, data_in, we, data_out);
    end

endmodule
