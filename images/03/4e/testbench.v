`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg bit_in;
    reg clk;
    reg we;
    reg word_line;
    wire bit_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .bit_in(bit_in),
        .clk(clk),
        .we(we),
        .word_line(word_line),
        .bit_out(bit_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            bit_in = 0;
            we = 0;
            word_line = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Write 0 and Read 0", test_num);
            reset_dut();


            word_line = 1;
            we = 1;
            bit_in = 0;
            @(posedge clk);
            #1;


            we = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write 1 and Read 1", test_num);
            reset_dut();


            word_line = 1;
            we = 1;
            bit_in = 1;
            @(posedge clk);
            #1;


            we = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify WE prevents overwriting when low", test_num);
            reset_dut();


            word_line = 1;
            we = 1;
            bit_in = 1;
            @(posedge clk);
            #1;


            we = 0;
            bit_in = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verify WL prevents writing when low", test_num);
            reset_dut();


            word_line = 1;
            we = 1;
            bit_in = 0;
            @(posedge clk);
            #1;


            word_line = 0;
            we = 1;
            bit_in = 1;
            @(posedge clk);
            #1;


            word_line = 1;
            we = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verify data persistence over multiple idle cycles", test_num);
            reset_dut();


            word_line = 1;
            we = 1;
            bit_in = 1;
            @(posedge clk);
            #1;


            word_line = 0;
            we = 0;
            repeat(3) @(posedge clk);
            #1;


            word_line = 1;
            @(posedge clk);
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
        input expected_bit_out;
        begin
            if (expected_bit_out === (expected_bit_out ^ bit_out ^ expected_bit_out)) begin
                $display("PASS");
                $display("  Outputs: bit_out=%b",
                         bit_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bit_out=%b",
                         expected_bit_out);
                $display("  Got:      bit_out=%b",
                         bit_out);
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
        $dumpvars(0,bit_in, clk, we, word_line, bit_out);
    end

endmodule
