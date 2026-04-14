`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg bit_line;
    reg [7:0] data_in;
    reg word_line;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .bit_line(bit_line),
        .data_in(data_in),
        .word_line(word_line),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        bit_line = 0;
        forever #5 bit_line = ~bit_line;
    end

        task reset_dut;

        begin
            word_line = 0;
            data_in = 8'h00;

            @(posedge bit_line);
            @(negedge bit_line);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;


            data_in = 8'hA5;
            word_line = 1;


            @(posedge bit_line);
            #2;


            #1;



            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;


            data_in = 8'h5A;
            word_line = 1;

            @(posedge bit_line);
            #2;


            #1;



            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;


            word_line = 1;
            data_in = 8'hFF;
            @(posedge bit_line);
            #2;
            word_line = 0;


            @(negedge bit_line);
            data_in = 8'h00;


            @(posedge bit_line);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            data_in = 8'h00;
            word_line = 1;

            @(posedge bit_line);
            #2;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;

            data_in = 8'hFF;
            word_line = 1;

            @(posedge bit_line);
            #2;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;


            data_in = 8'h12;
            word_line = 1;
            @(posedge bit_line);
            #2 word_line = 0;


            @(negedge bit_line);


            data_in = 8'h34;
            word_line = 1;
            @(posedge bit_line);
            #2;

            #1;


            check_outputs(8'h34);
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
        $dumpvars(0,bit_line, data_in, word_line, data_out);
    end

endmodule
