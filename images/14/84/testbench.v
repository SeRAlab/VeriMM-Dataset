`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] data_in;
    reg read_enable;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .data_in(data_in),
        .read_enable(read_enable),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        read_enable = 0;
        forever #5 read_enable = ~read_enable;
    end

        task reset_dut;

        begin
            write_enable = 1'b0;
            data_in = 8'h00;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read (0xAA)", test_num);
            reset_dut();

            data_in = 8'hAA;
            write_enable = 1'b1;
            #10;
            write_enable = 1'b0;

            wait(read_enable === 1'b1);
            #2;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read (0x55)", test_num);
            reset_dut();
            data_in = 8'h55;
            write_enable = 1'b1;
            #10;
            write_enable = 1'b0;
            wait(read_enable === 1'b1);
            #2;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Data Retention - WE=0", test_num);
            reset_dut();

            data_in = 8'hB4;
            write_enable = 1'b1;
            #10;

            write_enable = 1'b0;
            data_in = 8'hFF;
            #10;

            wait(read_enable === 1'b1);
            #2;
            #1;

            check_outputs(8'hB4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multiple Writes", test_num);
            reset_dut();

            data_in = 8'h11;
            write_enable = 1'b1;
            #10;

            data_in = 8'h22;
            #10;
            write_enable = 1'b0;
            wait(read_enable === 1'b1);
            #2;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Value 0xFF", test_num);
            reset_dut();
            data_in = 8'hFF;
            write_enable = 1'b1;
            #10;
            write_enable = 1'b0;
            wait(read_enable === 1'b1);
            #2;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Value 0x00", test_num);
            reset_dut();
            data_in = 8'h00;
            write_enable = 1'b1;
            #10;
            write_enable = 1'b0;
            wait(read_enable === 1'b1);
            #2;
            #1;

            check_outputs(8'h00);
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
        $dumpvars(0,data_in, read_enable, write_enable, data_out);
    end

endmodule
