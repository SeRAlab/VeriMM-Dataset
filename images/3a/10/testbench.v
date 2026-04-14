`timescale 1ns/1ps

module SRAM_Cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] address;
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
        address = 3'b000;
        data_in = 8'h00;
        write_enable = 0;

        #10;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Testcase %0d: Write 0xA5 to Address 0 and Read back", test_num);


        address = 3'd0;
        data_in = 8'hA5;
        write_enable = 1;
        #10;
        write_enable = 0;


        #5;
        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Testcase %0d: Write 0x5A to Address 7 and Read back", test_num);

        address = 3'd7;
        data_in = 8'h5A;
        write_enable = 1;
        #10;
        write_enable = 0;

        #5;
        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Testcase %0d: Write to multiple addresses and verify separation", test_num);


        address = 3'd1;
        data_in = 8'h11;
        write_enable = 1;
        #10;


        address = 3'd2;
        data_in = 8'h22;
        #10;
        write_enable = 0;


        address = 3'd1;
        #5;
        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(8'h11);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Testcase %0d: Overwrite Data at Address 4", test_num);


        address = 3'd4;
        data_in = 8'h00;
        write_enable = 1;
        #10;


        data_in = 8'hFF;
        #10;
        write_enable = 0;

        #5;
        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Testcase %0d: Verify Write Enable blocking", test_num);


        address = 3'd3;
        data_in = 8'h33;
        write_enable = 1;
        #10;


        write_enable = 0;
        data_in = 8'h44;
        #10;


        #5;
        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(8'h33);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = 6;
        $display("Testcase %0d: Test pattern 0xAA and 0x55 (All bits toggle)", test_num);

        address = 3'd5;
        data_in = 8'b10101010;
        write_enable = 1;
        #10;
        write_enable = 0;

        #5;
        wait(read_enable == 1);
        #2;
        #1;

        check_outputs(8'hAA);
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
        $dumpvars(0,address, data_in, read_enable, write_enable, data_out);
    end

endmodule
