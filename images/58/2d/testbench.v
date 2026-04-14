`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg areset;
    reg b;
    reg clk;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .areset(areset),
        .b(b),
        .clk(clk),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        areset = 0;
        forever #5 areset = ~areset;
    end

        task reset_dut;

        begin
            areset = 1;
            a = 0;
            b = 0;
            #15;
            areset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task send_serial_data;

        input [7:0] data_a;
        input [7:0] data_b;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                a = data_a[i];
                b = data_b[i];
                @(posedge clk);
                #1;
            end

            a = 0;
            b = 0;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            send_serial_data(8'd3, 8'd5);
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            send_serial_data(8'd10, 8'd12);
            #1;

            check_outputs(8'd120);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            send_serial_data(8'd15, 8'd15);
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            send_serial_data(8'd255, 8'd1);
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            send_serial_data(8'd128, 8'd2);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            send_serial_data(8'd0, 8'd255);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            send_serial_data(8'd7, 8'd9);
            #1;

            check_outputs(8'd63);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_product;
        begin
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
        $dumpvars(0,a, areset, b, clk, product);
    end

endmodule
