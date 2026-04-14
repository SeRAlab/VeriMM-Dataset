`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] channel_select;
    reg [15:0] mem_address;
    reg [15:0] peripheral_data;
    reg start;
    wire done;
    wire [15:0] mem_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel_select(channel_select),
        .mem_address(mem_address),
        .peripheral_data(peripheral_data),
        .start(start),
        .done(done),
        .mem_out(mem_out)
    );

    // Clock generation (10ns period)
    initial begin
        start = 0;
        forever #5 start = ~start;
    end

        task reset_dut;

    begin


        channel_select = 2'b00;
        mem_address = 16'h0000;
        peripheral_data = 16'h0000;
        #20;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Running Testcase 001: Channel 0 Transfer");
        channel_select = 2'b00;
        mem_address = 16'h1001;
        peripheral_data = 16'hABCD;
        #20;
        #1;

        check_outputs(1'b1, 16'hABCD);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Running Testcase 002: Channel 1 Transfer");
        channel_select = 2'b01;
        mem_address = 16'h2002;
        peripheral_data = 16'h1234;
        #20;
        #1;

        check_outputs(1'b1, 16'h1234);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Running Testcase 003: Channel 2 Transfer");
        channel_select = 2'b10;
        mem_address = 16'h3003;
        peripheral_data = 16'h55AA;
        #20;
        #1;

        check_outputs(1'b1, 16'h55AA);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Running Testcase 004: Channel 3 Transfer");
        channel_select = 2'b11;
        mem_address = 16'h4004;
        peripheral_data = 16'hF0F0;
        #20;
        #1;

        check_outputs(1'b1, 16'hF0F0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Running Testcase 005: Max values");
        channel_select = 2'b00;
        mem_address = 16'hFFFF;
        peripheral_data = 16'hFFFF;
        #20;
        #1;

        check_outputs(1'b1, 16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Running Testcase 006: Zero Data transfer");
        channel_select = 2'b10;
        mem_address = 16'h00A0;
        peripheral_data = 16'h0000;
        #20;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input expected_done;
        input [15:0] expected_mem_out;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_mem_out === (expected_mem_out ^ mem_out ^ expected_mem_out)) begin
                $display("PASS");
                $display("  Outputs: done=%b, mem_out=%h",
                         done, mem_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, mem_out=%h",
                         expected_done, expected_mem_out);
                $display("  Got:      done=%b, mem_out=%h",
                         done, mem_out);
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
        $dumpvars(0,channel_select, mem_address, peripheral_data, start, done, mem_out);
    end

endmodule
