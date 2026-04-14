`timescale 1ns/1ps

module spi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg serial_in;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    spi_controller dut (
        .clk(clk),
        .serial_in(serial_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            serial_in = 0;

            repeat(8) @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        integer i;
        reg [7:0] send_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sending 8'hA5 (10100101)", test_num);
            reset_dut();
            send_val = 8'hA5;
            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge clk);
                serial_in = send_val[i];
            end

            @(posedge clk);
            #2;
            #1;

            check_outputs(send_val);
        end
        endtask

    task testcase002;

        integer i;
        reg [7:0] send_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sending 8'h5A (01011010)", test_num);
            reset_dut();
            send_val = 8'h5A;
            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge clk);
                serial_in = send_val[i];
            end
            @(posedge clk);
            #2;
            #1;

            check_outputs(send_val);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] send_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sending 8'hFF", test_num);
            reset_dut();
            send_val = 8'hFF;
            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge clk);
                serial_in = send_val[i];
            end
            @(posedge clk);
            #2;
            #1;

            check_outputs(send_val);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] send_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sending 8'h00", test_num);
            reset_dut();
            send_val = 8'h00;
            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge clk);
                serial_in = send_val[i];
            end
            @(posedge clk);
            #2;
            #1;

            check_outputs(send_val);
        end
        endtask

    task testcase005;

        integer i;
        reg [7:0] send_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sending 8'h81 (10000001)", test_num);
            reset_dut();
            send_val = 8'h81;
            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge clk);
                serial_in = send_val[i];
            end
            @(posedge clk);
            #2;
            #1;

            check_outputs(send_val);
        end
        endtask

    task testcase006;

        integer i;
        reg [7:0] send_val;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sending 8'h3C (00111100)", test_num);
            reset_dut();
            send_val = 8'h3C;
            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge clk);
                serial_in = send_val[i];
            end
            @(posedge clk);
            #2;
            #1;

            check_outputs(send_val);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("spi_controller Testbench");
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
        $dumpvars(0,clk, serial_in, data_out);
    end

endmodule
