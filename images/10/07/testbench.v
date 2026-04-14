`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg word_select;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .data_in(data_in),
        .word_select(word_select),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        word_select = 0;
        forever #5 word_select = ~word_select;
    end

        task reset_dut;

        begin
            data_in = 8'h00;
            write_enable = 0;

            @(posedge word_select);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read (0xAA)", test_num);
            reset_dut();


            data_in = 8'hAA;
            write_enable = 1;
            @(posedge word_select);
            #2;


            write_enable = 0;
            @(posedge word_select);
            #2;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write and Read (0x55)", test_num);
            reset_dut();


            data_in = 8'h55;
            write_enable = 1;
            @(posedge word_select);
            #2;


            write_enable = 0;
            @(posedge word_select);
            #2;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Persistence (Write 0xFF, change input, verify stored value)", test_num);
            reset_dut();


            data_in = 8'hFF;
            write_enable = 1;
            @(posedge word_select);
            #2;


            write_enable = 0;
            data_in = 8'h00;


            @(posedge word_select);
            #2;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify No Write when write_enable is low", test_num);
            reset_dut();


            data_in = 8'h12;
            write_enable = 1;
            @(posedge word_select);
            #2;


            data_in = 8'h34;
            write_enable = 0;
            @(posedge word_select);
            #2;


            @(posedge word_select);
            #2;

            #1;


            check_outputs(8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write and Read 0x00", test_num);
            reset_dut();


            data_in = 8'h00;
            write_enable = 1;
            @(posedge word_select);
            #2;


            write_enable = 0;
            @(posedge word_select);
            #2;

            #1;


            check_outputs(8'h00);
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
        $dumpvars(0,data_in, word_select, write_enable, data_out);
    end

endmodule
