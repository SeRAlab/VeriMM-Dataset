`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg [3:0] data_in;
    reg read_enable;
    reg write_enable;
    wire [3:0] data_out;

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
            address = 0;
            data_in = 0;
            write_enable = 0;

            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Write 4'hA to Address 0 and Verify");
            reset_dut();


            address = 2'b00;
            data_in = 4'hA;
            write_enable = 1;
            #10;
            write_enable = 0;


            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Write 4'h5 to Address 3 and Verify");
            reset_dut();


            address = 2'b11;
            data_in = 4'h5;
            write_enable = 1;
            #10;
            write_enable = 0;


            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Verify Write Enable functionality (WE=0 should not write)");
            reset_dut();


            address = 2'b01;
            data_in = 4'hF;
            write_enable = 1;
            #10;


            data_in = 4'h0;
            write_enable = 0;
            #10;


            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Verify address isolation (Writing Addr 2 doesn't affect Addr 1)");
            reset_dut();


            address = 2'b01; data_in = 4'hC; write_enable = 1;
            #10;

            address = 2'b10; data_in = 4'h3; write_enable = 1;
            #10;
            write_enable = 0;


            address = 2'b01;
            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Data persistence across all memory locations");
            reset_dut();


            address = 2'b00; data_in = 4'h1; write_enable = 1; #10;
            address = 2'b01; data_in = 4'h2; write_enable = 1; #10;
            address = 2'b10; data_in = 4'h4; write_enable = 1; #10;
            address = 2'b11; data_in = 4'h8; write_enable = 1; #10;
            write_enable = 0;


            address = 2'b11;
            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Verify overwriting existing data");
            reset_dut();


            address = 2'b00; data_in = 4'hA; write_enable = 1; #10;

            address = 2'b00; data_in = 4'hB; write_enable = 1; #10;
            write_enable = 0;


            wait(read_enable == 1);
            #2;
            #1;

            check_outputs(4'hB);
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
        input [3:0] expected_data_out;
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
