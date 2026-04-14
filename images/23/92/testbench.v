`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] data_in;
    reg word_line;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .data_in(data_in),
        .word_line(word_line),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        word_line = 0;
        forever #5 word_line = ~word_line;
    end

        task reset_dut;

    begin
        data_in = 4'h0;

        @(posedge word_line);
        @(negedge word_line);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Write 4'hA and verify storage", test_num);
        reset_dut();
        data_in = 4'hA;
        @(posedge word_line);
        @(negedge word_line);
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Write 4'h5 and verify storage", test_num);
        reset_dut();
        data_in = 4'h5;
        @(posedge word_line);
        @(negedge word_line);
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Data retention with changing input", test_num);
        reset_dut();


        data_in = 4'hC;
        @(posedge word_line);
        @(negedge word_line);


        data_in = 4'h3;
        #2;


        #1;



        check_outputs(4'hC);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Write all ones (4'hF)", test_num);
        reset_dut();
        data_in = 4'hF;
        @(posedge word_line);
        @(negedge word_line);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Write all zeros (4'h0)", test_num);

        data_in = 4'hF;
        @(posedge word_line);
        @(negedge word_line);


        data_in = 4'h0;
        @(posedge word_line);
        @(negedge word_line);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Verify no write occurs if word_line is held low", test_num);
        reset_dut();


        @(negedge word_line);
        data_in = 4'h9;



        #2;
        #1;

        check_outputs(4'h0);
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,data_in, word_line, data_out);
    end

endmodule
