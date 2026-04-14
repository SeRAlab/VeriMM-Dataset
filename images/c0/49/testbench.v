`timescale 1ns/1ps

module stratix_lvds_rx_tb;

    // Testbench signals (sequential circuit)
    reg rx_enable0;
    reg rx_enable1;
    reg rx_fastclk;
    reg rx_in;
    wire [3:0] rx_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stratix_lvds_rx dut (
        .rx_enable0(rx_enable0),
        .rx_enable1(rx_enable1),
        .rx_fastclk(rx_fastclk),
        .rx_in(rx_in),
        .rx_out(rx_out)
    );

    // Clock generation (10ns period)
    initial begin
        rx_fastclk = 0;
        forever #5 rx_fastclk = ~rx_fastclk;
    end

        task reset_dut;

        begin
            rx_enable0 = 0;
            rx_enable1 = 0;
            rx_in = 0;

            repeat (5) @(posedge rx_fastclk);
        end
        endtask
    task send_serial_data;

        input [3:0] data;
        input bit_enable_load;
        integer i;
        begin
            for (i = 3; i >= 0; i = i - 1) begin
                @(negedge rx_fastclk);
                rx_in = data[i];
                if (i == 0 && bit_enable_load) begin
                    rx_enable0 = 1;
                end
            end
            @(negedge rx_fastclk);
            rx_enable0 = 0;
        end
        endtask

    task update_output_hold;

        begin
            #2;
            rx_enable1 = 1;
            #10;
            rx_enable1 = 0;
        end
        endtask

    task testcase001;

        begin
            $display("Running Testcase 001: Basic Deserialization 1011...");
            reset_dut();
            send_serial_data(4'b1011, 1);
            update_output_hold();
            #10;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Basic Deserialization 0101...");
            reset_dut();
            send_serial_data(4'b0101, 1);
            update_output_hold();
            #10;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: rx_enable0 Gating Check...");


            reset_dut();

            send_serial_data(4'b1010, 1);
            update_output_hold();


            send_serial_data(4'b1111, 0);
            update_output_hold();
            #10;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: rx_enable1 Gating Check...");
            reset_dut();

            send_serial_data(4'b0011, 1);
            update_output_hold();


            send_serial_data(4'b1100, 1);

            #20;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stratix_lvds_rx Testbench");
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
        input [3:0] expected_rx_out;
        begin
            if (expected_rx_out === (expected_rx_out ^ rx_out ^ expected_rx_out)) begin
                $display("PASS");
                $display("  Outputs: rx_out=%h",
                         rx_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rx_out=%h",
                         expected_rx_out);
                $display("  Got:      rx_out=%h",
                         rx_out);
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
        $dumpvars(0,rx_enable0, rx_enable1, rx_fastclk, rx_in, rx_out);
    end

endmodule
