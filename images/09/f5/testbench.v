`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] data_in;
    reg word_line;
    reg write_enable;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .data_in(data_in),
        .word_line(word_line),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        word_line = 0;
        forever #5 word_line = ~word_line;
    end

        task reset_dut;

    begin
        data_in = 16'h0000;
        write_enable = 0;

        @(negedge word_line);
        write_enable = 1;
        data_in = 16'h0000;
        @(negedge word_line);
        write_enable = 0;
        data_in = 16'hzzzz;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Write and Read 0xAAAA", test_num);
        @(negedge word_line);
        data_in = 16'hAAAA;
        write_enable = 1;
        @(negedge word_line);
        write_enable = 0;
        data_in = 16'hzzzz;

        @(posedge word_line);
        #2;
        #1;

        check_outputs(16'hAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Write and Read 0x5555", test_num);
        @(negedge word_line);
        data_in = 16'h5555;
        write_enable = 1;
        @(negedge word_line);
        write_enable = 0;
        data_in = 16'hzzzz;
        @(posedge word_line);
        #2;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Write and Read 0xFFFF", test_num);
        @(negedge word_line);
        data_in = 16'hFFFF;
        write_enable = 1;
        @(negedge word_line);
        write_enable = 0;
        @(posedge word_line);
        #2;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Persistence check (WE=0 prevents write)", test_num);

        @(negedge word_line);
        data_in = 16'h1234;
        write_enable = 1;
        @(negedge word_line);

        write_enable = 0;
        data_in = 16'hFFFF;
        @(negedge word_line);

        @(posedge word_line);
        #2;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Overwrite check", test_num);
        @(negedge word_line);
        data_in = 16'h1111;
        write_enable = 1;
        @(negedge word_line);
        data_in = 16'h2222;
        @(negedge word_line);
        write_enable = 0;
        @(posedge word_line);
        #2;
        #1;

        check_outputs(16'h2222);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Pattern 0x0F0F", test_num);
        @(negedge word_line);
        data_in = 16'h0F0F;
        write_enable = 1;
        @(negedge word_line);
        write_enable = 0;
        @(posedge word_line);
        #2;
        #1;

        check_outputs(16'h0F0F);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,data_in, word_line, write_enable, data_out);
    end

endmodule
