`timescale 1ns/1ps

module dram_4bit_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] column_address;
    reg [3:0] data_in;
    reg [1:0] row_address;
    reg write_enable;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_4bit dut (
        .column_address(column_address),
        .data_in(data_in),
        .row_address(row_address),
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
        row_address = 0;
        column_address = 0;
        data_in = 0;

        @(negedge write_enable);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Simple Write/Read (0,0)", test_num);
        reset_dut();


        @(posedge write_enable);
        row_address = 2'b00;
        column_address = 2'b00;
        data_in = 4'hA;


        @(negedge write_enable);
        #1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary Address (3,3)", test_num);
        reset_dut();


        @(posedge write_enable);
        row_address = 2'b11;
        column_address = 2'b11;
        data_in = 4'h5;


        @(negedge write_enable);
        #1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Address Independence Check", test_num);
        reset_dut();


        @(posedge write_enable);
        row_address = 2'b01; column_address = 2'b01; data_in = 4'hF;


        @(posedge write_enable);
        row_address = 2'b01; column_address = 2'b10; data_in = 4'h3;


        @(negedge write_enable);
        row_address = 2'b01; column_address = 2'b01;
        #1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overwrite Data", test_num);
        reset_dut();


        @(posedge write_enable);
        row_address = 2'b10; column_address = 2'b00; data_in = 4'h1;


        @(posedge write_enable);
        row_address = 2'b10; column_address = 2'b00; data_in = 4'hE;


        @(negedge write_enable);
        #1;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Full 4-bit Logic High/Low Check", test_num);
        reset_dut();


        @(posedge write_enable);
        row_address = 2'b00; column_address = 2'b10; data_in = 4'b1010;

        @(negedge write_enable);
        #1;
        #1;

        check_outputs(4'b1010);


        @(posedge write_enable);
        data_in = 4'b0101;

        @(negedge write_enable);
        #1;
        #1;

        check_outputs(4'b0101);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_4bit Testbench");
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
        $dumpvars(0,column_address, data_in, row_address, write_enable, data_out);
    end

endmodule
