`timescale 1ns/1ps

module uart_receiver_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg serial_in;
    wire [7:0] data_out;
    wire data_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    uart_receiver dut (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .data_out(data_out),
        .data_ready(data_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            serial_in = 1;
            repeat(5) @(posedge clk);
            reset = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task send_byte;

        input [7:0] data;
        integer i;
        begin

            serial_in = 0;
            repeat(CLKS_PER_BIT) @(posedge clk);


            for (i = 0; i < 8; i = i + 1) begin
                serial_in = data[i];
                repeat(CLKS_PER_BIT) @(posedge clk);
            end


            serial_in = 1;
            repeat(CLKS_PER_BIT) @(posedge clk);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Receive 0xA5", test_num);
            reset_dut();
            send_byte(8'hA5);


            wait(data_ready == 1);
            #1;

            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Receive 0x5A", test_num);
            reset_dut();
            send_byte(8'h5A);

            wait(data_ready == 1);
            #1;

            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Receive All Zeros (0x00)", test_num);
            reset_dut();
            send_byte(8'h00);

            wait(data_ready == 1);
            #1;

            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Receive All Ones (0xFF)", test_num);
            reset_dut();
            send_byte(8'hFF);

            wait(data_ready == 1);
            #1;

            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Consecutive transmissions", test_num);
            reset_dut();


            send_byte(8'h3C);
            wait(data_ready == 1);
            @(posedge clk);


            send_byte(8'hC3);
            wait(data_ready == 1);

            #1;


            check_outputs(8'hC3, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("uart_receiver Testbench");
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
        input expected_data_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, data_ready=%b",
                         data_out, data_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, data_ready=%b",
                         expected_data_out, expected_data_ready);
                $display("  Got:      data_out=%h, data_ready=%b",
                         data_out, data_ready);
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
        $dumpvars(0,clk, reset, serial_in, data_out, data_ready);
    end

endmodule
