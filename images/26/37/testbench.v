`timescale 1ns/1ps

module uart_receiver_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg rx;
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
        .rx(rx),
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
            rx = 1;
            @(posedge clk);
            @(posedge clk);
            reset = 0;
            @(posedge clk);
        end
        endtask
    task send_uart_byte;

        input [7:0] data;
        integer i;
        begin

            rx = 0;
            @(posedge clk);


            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                @(posedge clk);
            end


            rx = 1;
            @(posedge clk);


            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Receiving 0xA5", test_num);
            reset_dut();

            send_uart_byte(8'hA5);


            #1;



            check_outputs(8'hA5, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Receiving 0x5A", test_num);
            reset_dut();

            send_uart_byte(8'h5A);

            #1;


            check_outputs(8'h5A, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Receiving 0xFF", test_num);
            reset_dut();

            send_uart_byte(8'hFF);

            #1;


            check_outputs(8'hFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Receiving 0x00", test_num);
            reset_dut();

            send_uart_byte(8'h00);

            #1;


            check_outputs(8'h00, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("\nTest Case %0d: Reset during transmission", test_num);
            reset_dut();


            rx = 0;
            @(posedge clk);

            for (i = 0; i < 4; i = i + 1) begin
                rx = 1;
                @(posedge clk);
            end


            reset = 1;
            @(posedge clk);
            reset = 0;
            rx = 1;
            @(posedge clk);



            #1;




            check_outputs(8'h00, 1'b0);
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
        $dumpvars(0,clk, reset, rx, data_out, data_ready);
    end

endmodule
