`timescale 1ns/1ps

module shift_reg_8bit_tb;

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
    shift_reg_8bit dut (
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
            data_in = 8'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Loading 8'hA5 and checking MSB", test_num);
            reset_dut();

            data_in = 8'hA5;
            load = 1;
            @(posedge clk);
            #1;
            load = 0;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Loading 8'hA5, shift 1, check bit 6", test_num);
            reset_dut();

            data_in = 8'hA5;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            shift = 1;
            @(posedge clk);
            #1;
            shift = 0;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Loading 8'hF0, shift 4, check bit", test_num);
            reset_dut();

            data_in = 8'hF0;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            shift = 1;
            repeat(4) @(posedge clk);
            #1;
            shift = 0;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Loading 8'hFF, shift 7, check LSB", test_num);
            reset_dut();

            data_in = 8'hFF;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            shift = 1;
            repeat(7) @(posedge clk);
            #1;
            shift = 0;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing Load priority over Shift", test_num);
            reset_dut();


            data_in = 8'h00;
            load = 1;
            @(posedge clk);
            #1;


            data_in = 8'h80;
            load = 1;
            shift = 1;
            @(posedge clk);
            #1;

            load = 0;
            shift = 0;


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Data stability test", test_num);
            reset_dut();

            data_in = 8'hAA;
            load = 1;
            @(posedge clk);
            #1;

            load = 0;
            shift = 0;
            repeat(5) @(posedge clk);
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
        $display("shift_reg_8bit Testbench");
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
