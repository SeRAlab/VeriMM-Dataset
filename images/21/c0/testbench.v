`timescale 1ns/1ps

module crc_generator_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg data_in;
    reg reset;
    reg valid;
    wire [15:0] crc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    crc_generator dut (
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .valid(valid),
        .crc_out(crc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        data_in = 0;
        valid = 0;
        @(posedge clk);
        #1 reset = 0;
        @(posedge clk);
    end
        endtask
    task send_16bit_data;

        input [15:0] data;
        integer i;
        begin
            valid = 1;
            for (i = 15; i >= 0; i = i - 1) begin
                data_in = data[i];
                @(posedge clk);
            end
            valid = 0;
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Data=0x0000", test_num);
        reset_dut();
        send_16bit_data(16'h0000);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Data=0x0001", test_num);
        reset_dut();
        send_16bit_data(16'h0001);
        #1;

        check_outputs(16'h1021);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Data=0x8000", test_num);
        reset_dut();
        send_16bit_data(16'h8000);
        #1;

        check_outputs(16'h9479);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Data=0x1234", test_num);
        reset_dut();
        send_16bit_data(16'h1234);
        #1;

        check_outputs(16'hCF1E);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Data=0xFFFF", test_num);
        reset_dut();
        send_16bit_data(16'hFFFF);
        #1;

        check_outputs(16'h1D0F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Data=0xAAAA", test_num);
        reset_dut();
        send_16bit_data(16'hAAAA);
        #1;

        check_outputs(16'h2973);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("crc_generator Testbench");
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
        input [15:0] expected_crc_out;
        begin
            if (expected_crc_out === (expected_crc_out ^ crc_out ^ expected_crc_out)) begin
                $display("PASS");
                $display("  Outputs: crc_out=%h",
                         crc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: crc_out=%h",
                         expected_crc_out);
                $display("  Got:      crc_out=%h",
                         crc_out);
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
        $dumpvars(0,clk, data_in, reset, valid, crc_out);
    end

endmodule
