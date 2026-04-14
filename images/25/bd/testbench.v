`timescale 1ns/1ps

module piso_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg shift;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    piso_shift_register dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .shift(shift),
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
            shift = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 8'h80, enable shift, check MSB (Bit 7)", test_num);
            reset_dut();
            data_in = 8'h80;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 8'h01, shift 7 times, check LSB (Bit 0)", test_num);
            reset_dut();
            data_in = 8'h01;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 8'hAA (10101010), shift 1 time, check Bit 6 (should be 0)", test_num);
            reset_dut();
            data_in = 8'hAA;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 8'h55 (01010101), shift 1 time, check Bit 6 (should be 1)", test_num);
            reset_dut();
            data_in = 8'h55;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 8'hFF, shift signal low, check if serial_out is invalid/0", test_num);
            reset_dut();
            data_in = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 8'hF0 (11110000), shift 3 times, check Bit 4 (should be 1)", test_num);
            reset_dut();
            data_in = 8'hF0;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 8'h0F (00001111), shift 3 times, check Bit 4 (should be 0)", test_num);
            reset_dut();
            data_in = 8'h0F;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 8'hFF, shift 7 times, check LSB (should be 1)", test_num);
            reset_dut();
            data_in = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;
            shift = 1;
            repeat(7) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("piso_shift_register Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        $dumpvars(0,clk, data_in, load, shift, serial_out);
    end

endmodule
