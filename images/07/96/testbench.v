`timescale 1ns/1ps

module i2c_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address;
    reg clk;
    reg [7:0] data_in;
    reg enable;
    reg start;
    reg stop;
    wire ack;
    wire data_out;
    wire scl;
    wire sda;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_controller dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .start(start),
        .stop(stop),
        .ack(ack),
        .data_out(data_out),
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
            address = 8'h0;
            data_in = 8'h0;
            enable = 0;
            start = 0;
            stop = 0;
            sda_drive = 1'bz;
            repeat(5) @(posedge clk);
        end
        endtask
    task simulate_slave_ack;

        begin

            repeat(8) @(negedge scl);

            #2 sda_drive = 0;
            @(negedge scl);
            #2 sda_drive = 1'bz;
        end
        endtask

    task simulate_slave_transmit;

        input [7:0] slave_data;
        integer i;
        begin

            repeat(9) @(negedge scl);

            for (i = 7; i >= 0; i = i - 1) begin
                sda_drive = slave_data[i];
                @(negedge scl);
            end
            sda_drive = 1'bz;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write (Address 0xA0, Data 0x3C)", test_num);
            reset_dut();

            address = 8'hA0;
            data_in = 8'h3C;
            enable = 1;
            start = 1;

            fork
                simulate_slave_ack();
                simulate_slave_ack();
            join_none



            #1000;
            stop = 1;
            #20 stop = 0;
            #50;


            #1;



            check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write with Slave NACK (Address 0x55)", test_num);
            reset_dut();

            address = 8'h55;
            data_in = 8'hFF;
            enable = 1;
            start = 1;



            #1000;
            stop = 1;
            #20 stop = 0;
            #50;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Read (Slave sends 0x12)", test_num);
            reset_dut();

            address = 8'hA1;
            enable = 1;
            start = 1;

            fork
                simulate_slave_ack();
                simulate_slave_transmit(8'h12);
            join_none

            #1000;
            stop = 1;
            #20 stop = 0;
            #50;


            #1;



            check_outputs(1'b1, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Idle State (Enable Low)", test_num);
            reset_dut();

            enable = 0;
            start = 1;

            #200;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("i2c_controller Testbench");
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
        input expected_ack;
        input expected_data_out;
        input expected_scl;
        input expected_sda;
        begin
            if (expected_ack === (expected_ack ^ ack ^ expected_ack) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_scl === (expected_scl ^ scl ^ expected_scl) &&
                expected_sda === (expected_sda ^ sda ^ expected_sda)) begin
                $display("PASS");
                $display("  Outputs: ack=%b, data_out=%b, scl=%b, sda=%b",
                         ack, data_out, scl, sda);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ack=%b, data_out=%b, scl=%b, sda=%b",
                         expected_ack, expected_data_out, expected_scl, expected_sda);
                $display("  Got:      ack=%b, data_out=%b, scl=%b, sda=%b",
                         ack, data_out, scl, sda);
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
        $dumpvars(0,address, clk, data_in, enable, start, stop, ack, data_out, scl, sda);
    end

endmodule
