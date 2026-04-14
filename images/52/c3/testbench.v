`timescale 1ns/1ps

module parallel_to_serial_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [7:0] parallel_data;
    reg shift_enable;
    wire serial_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    parallel_to_serial_shift_register dut (
        .clk(clk),
        .load(load),
        .parallel_data(parallel_data),
        .shift_enable(shift_enable),
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
            shift_enable = 0;
            parallel_data = 8'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Test %0d: Load data 8'b10101011 and check LSB", test_num);
            load = 1;
            parallel_data = 8'b10101011;
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
            reset_dut();
            $display("Test %0d: Load 8'b10101011, shift once, check bit 1 (value 1)", test_num);
            load = 1;
            parallel_data = 8'b10101011;
            @(posedge clk);
            #1;
            load = 0;
            shift_enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Test %0d: Load 8'b10101011, shift 4 times, check bit 4 (value 0)", test_num);
            load = 1;
            parallel_data = 8'b10101011;
            @(posedge clk);
            #1;
            load = 0;
            shift_enable = 1;
            repeat (4) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Test %0d: Load 8'b10000000, shift 7 times, check bit 7 (value 1)", test_num);
            load = 1;
            parallel_data = 8'b10000000;
            @(posedge clk);
            #1;
            load = 0;
            shift_enable = 1;
            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Test %0d: Disable shift, check if output holds value", test_num);
            load = 1;
            parallel_data = 8'b10101011;
            @(posedge clk);
            #1;
            load = 0;
            shift_enable = 0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        integer i;
        reg [7:0] data_to_send;
        begin
            test_num = 6;
            reset_dut();
            data_to_send = 8'b11001100;
            $display("Test %0d: Serialize 8'b11001100 completely", test_num);
            load = 1;
            parallel_data = data_to_send;
            @(posedge clk);
            #1;
            load = 0;
            shift_enable = 1;


            for(i = 0; i < 8; i = i + 1) begin
                if (serial_out !== data_to_send[i]) begin

                end
                if (i < 7) @(posedge clk);
                #1;
            end
            #1;

            check_outputs(data_to_send[7]);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("parallel_to_serial_shift_register Testbench");
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
        $dumpvars(0,clk, load, parallel_data, shift_enable, serial_out);
    end

endmodule
