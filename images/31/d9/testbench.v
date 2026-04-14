`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] address;
    reg [15:0] data_in;
    reg read_enable;
    reg write_enable;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    SRAM_Cell dut (
        .address(address),
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
            address = 4'h0;
            data_in = 16'h0;
            write_enable = 1'b0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Write and Read (Addr 0)", test_num);
            reset_dut();

            address = 4'h0;
            data_in = 16'hA5A5;
            write_enable = 1;
            #10;
            write_enable = 0;


            wait(read_enable == 1'b1);
            #1;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Address Check (Addr 15)", test_num);
            reset_dut();

            address = 4'hF;
            data_in = 16'h5A5A;
            write_enable = 1;
            #10;
            write_enable = 0;

            wait(read_enable == 1'b1);
            #1;
            #1;

            check_outputs(16'h5A5A);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Overwrite Data (Addr 7)", test_num);
            reset_dut();


            address = 4'h7;
            data_in = 16'h1111;
            write_enable = 1;
            #10;


            data_in = 16'hEEEE;
            #10;
            write_enable = 0;

            wait(read_enable == 1'b1);
            #1;
            #1;

            check_outputs(16'hEEEE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Multi-address Persistence", test_num);
            reset_dut();


            address = 4'hA;
            data_in = 16'hAAAA;
            write_enable = 1;
            #10;


            address = 4'hB;
            data_in = 16'hBBBB;
            write_enable = 1;
            #10;
            write_enable = 0;


            address = 4'hA;
            #5;
            wait(read_enable == 1'b1);
            #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full Bit-width Check (0xFFFF)", test_num);
            reset_dut();

            address = 4'h5;
            data_in = 16'hFFFF;
            write_enable = 1;
            #10;
            write_enable = 0;

            wait(read_enable == 1'b1);
            #1;
            #1;

            check_outputs(16'hFFFF);
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
        input [15:0] expected_data_out;
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
        $dumpvars(0,address, data_in, read_enable, write_enable, data_out);
    end

endmodule
