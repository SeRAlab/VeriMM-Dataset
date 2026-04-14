`timescale 1ns/1ps

module i2c_master_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data;
    reg rst;
    reg [6:0] slave_addr;
    reg start;
    wire done;
    wire scl;
    wire sda;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_master dut (
        .clk(clk),
        .data(data),
        .rst(rst),
        .slave_addr(slave_addr),
        .start(start),
        .done(done),
        .scl(scl),
        .sda(sda)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            data = 8'h0;
            slave_addr = 7'h0;
            sda_slave_drive = 1'bz;
            repeat(5) @(posedge clk);
            rst = 0;
            repeat(5) @(posedge clk);
        end
        endtask
    task wait_for_ack_slot;

        integer i;
        begin


            for (i = 0; i < 8; i = i + 1) begin
                @(negedge scl);
            end


            #1;
            sda_slave_drive = 1'b0;
            @(negedge scl);
            #1;
            sda_slave_drive = 1'bz;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write 0xAA to Slave Addr 0x50", test_num);
            reset_dut();

            slave_addr = 7'h50;
            data = 8'hAA;
            start = 1;
            @(posedge clk);
            start = 0;


            wait_for_ack_slot();

            wait_for_ack_slot();


            wait(done == 1);
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write 0x55 to Slave Addr 0x21", test_num);
            reset_dut();

            slave_addr = 7'h21;
            data = 8'h55;
            start = 1;
            @(posedge clk);
            start = 0;

            wait_for_ack_slot();
            wait_for_ack_slot();

            wait(done == 1);
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write 0xFF to Max Slave Addr 0x7F", test_num);
            reset_dut();

            slave_addr = 7'h7F;
            data = 8'hFF;
            start = 1;
            @(posedge clk);
            start = 0;

            wait_for_ack_slot();
            wait_for_ack_slot();

            wait(done == 1);
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write 0x00 to Slave Addr 0x00", test_num);
            reset_dut();

            slave_addr = 7'h00;
            data = 8'h00;
            start = 1;
            @(posedge clk);
            start = 0;

            wait_for_ack_slot();
            wait_for_ack_slot();

            wait(done == 1);
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("i2c_master Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_scl;
        input expected_sda;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_scl === (expected_scl ^ scl ^ expected_scl) &&
                expected_sda === (expected_sda ^ sda ^ expected_sda)) begin
                $display("PASS");
                $display("  Outputs: done=%b, scl=%b, sda=%b",
                         done, scl, sda);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, scl=%b, sda=%b",
                         expected_done, expected_scl, expected_sda);
                $display("  Got:      done=%b, scl=%b, sda=%b",
                         done, scl, sda);
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
        $dumpvars(0,clk, data, rst, slave_addr, start, done, scl, sda);
    end

endmodule
