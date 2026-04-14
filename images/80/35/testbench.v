`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .serial_out(serial_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            data_in <= 8'h00;
            load <= 1;
            @(posedge clk);
            load <= 0;
            data_in <= 8'h00;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Load 0x01 and check serial_out...");
            test_num = 1;
            reset_dut();
            @(posedge clk);
            data_in <= 8'b00000001;
            load <= 1;
            @(posedge clk);
            load <= 0;

            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Load 0x02, shift right 1 time...");
            test_num = 2;
            reset_dut();
            @(posedge clk);
            data_in <= 8'b00000010;
            load <= 1;
            @(posedge clk);
            load <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Load 0x80, shift right 7 times...");
            test_num = 3;
            reset_dut();
            @(posedge clk);
            data_in <= 8'b10000000;
            load <= 1;
            @(posedge clk);
            load <= 0;
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Load 0xAA, shift right 1 time...");
            test_num = 4;
            reset_dut();
            @(posedge clk);
            data_in <= 8'b10101010;
            load <= 1;
            @(posedge clk);
            load <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Load 0x55, shift right 1 time...");
            test_num = 5;
            reset_dut();
            @(posedge clk);
            data_in <= 8'b01010101;
            load <= 1;
            @(posedge clk);
            load <= 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Load 0xFF, shift right 7 times...");
            test_num = 6;
            reset_dut();
            @(posedge clk);
            data_in <= 8'b11111111;
            load <= 1;
            @(posedge clk);
            load <= 0;
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Load 0x00 and check serial_out...");
            test_num = 7;
            reset_dut();
            @(posedge clk);
            data_in <= 8'b00000000;
            load <= 1;
            @(posedge clk);
            load <= 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input expected_serial_out;
        begin
            if (expected_serial_out === (expected_serial_out ^ serial_out ^ expected_serial_out)) begin
                $display("PASS");
                $display("  Outputs: serial_out=%b",
                         serial_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_out=%b",
                         expected_serial_out);
                $display("  Got:      serial_out=%b",
                         serial_out);
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
        $dumpvars(0,clk, data_in, load, serial_out);
    end

endmodule
