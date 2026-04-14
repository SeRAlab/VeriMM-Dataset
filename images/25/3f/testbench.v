`timescale 1ns/1ps

module PISO_Shift_Register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] data;
    reg load;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    PISO_Shift_Register dut (
        .clk(clk),
        .data(data),
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
            load = 0;
            data = 0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Load 5'b10101 - Check Bit 4", test_num);
            reset_dut();
            data = 5'b10101;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load 5'b10101 - Check Bit 3 (1 shift)", test_num);
            reset_dut();
            data = 5'b10101;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Load 5'b10101 - Check Bit 2 (2 shifts)", test_num);
            reset_dut();
            data = 5'b10101;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Load 5'b10101 - Check Bit 1 (3 shifts)", test_num);
            reset_dut();
            data = 5'b10101;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Load 5'b10101 - Check Bit 0 (4 shifts)", test_num);
            reset_dut();
            data = 5'b10101;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Load 5'b11111 - Check MSB", test_num);
            reset_dut();
            data = 5'b11111;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Load 5'b00000 - Check MSB", test_num);
            reset_dut();
            data = 5'b00000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Load 5'b01111 - Check Bit 0", test_num);
            reset_dut();
            data = 5'b01111;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Test Load overriding Shift logic", test_num);
            reset_dut();
            data = 5'b11111;
            load = 1;
            @(posedge clk);
            #1 data = 5'b00000;
            load = 1;
            @(posedge clk);
            #1 load = 0;
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
        $display("PISO_Shift_Register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        
        
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
        $dumpvars(0,clk, data, load, serial_out);
    end

endmodule
