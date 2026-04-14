`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] address;
    reg [7:0] data_in;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .address(address),
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        write_enable = 0;
        forever #5 write_enable = ~write_enable;
    end

        task reset_dut;

        begin
            address = 0;
            data_in = 0;


            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read Address 0", test_num);
            reset_dut();

            address = 3'b000;
            data_in = 8'hA5;

            wait(write_enable == 1);
            #5;

            wait(write_enable == 0);
            #2;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write and Read Address 7", test_num);
            reset_dut();

            address = 3'b111;
            data_in = 8'h5A;
            wait(write_enable == 1);
            #5;
            wait(write_enable == 0);
            #2;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Address 2", test_num);
            reset_dut();


            address = 3'b010;
            data_in = 8'h11;
            wait(write_enable == 1);
            #5;


            data_in = 8'hFF;
            wait(write_enable == 1);
            #5;


            wait(write_enable == 0);
            #2;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Persistence check Address 4", test_num);
            reset_dut();


            address = 3'b100;
            data_in = 8'hDE;
            wait(write_enable == 1);
            #5;


            address = 3'b101;
            data_in = 8'hAD;
            wait(write_enable == 1);
            #5;


            address = 3'b100;
            wait(write_enable == 0);
            #2;

            #1;


            check_outputs(8'hDE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All bits high/low at Address 3", test_num);
            reset_dut();


            address = 3'b011;
            data_in = 8'h00;
            wait(write_enable == 1);
            #10;


            data_in = 8'hFF;
            wait(write_enable == 1);
            #5;

            wait(write_enable == 0);
            #2;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("SRAM_Cell Testbench");
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
        $dumpvars(0,address, data_in, write_enable, data_out);
    end

endmodule
