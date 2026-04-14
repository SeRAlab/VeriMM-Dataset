`timescale 1ns/1ps

module sram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg chip_enable;
    reg [7:0] data_in;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_cell dut (
        .addr(addr),
        .chip_enable(chip_enable),
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        chip_enable = 0;
        forever #5 chip_enable = ~chip_enable;
    end

        task reset_dut;

    begin
        addr = 3'b000;
        data_in = 8'h00;
        write_enable = 0;

        repeat(2) @(posedge chip_enable);
        #2;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Basic Write and Read at Addr 0", test_num);
        reset_dut();


        @(negedge chip_enable);
        addr = 3'b000;
        data_in = 8'hA5;
        write_enable = 1;
        @(posedge chip_enable);


        #(2);
        write_enable = 0;
        @(posedge chip_enable);

        #(2);
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Write and Read at Max Addr 7", test_num);
        reset_dut();


        @(negedge chip_enable);
        addr = 3'b111;
        data_in = 8'h5A;
        write_enable = 1;
        @(posedge chip_enable);


        #(2);
        write_enable = 0;
        @(posedge chip_enable);

        #(2);
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Overwrite Data at Addr 3", test_num);
        reset_dut();


        @(negedge chip_enable);
        addr = 3'b011;
        data_in = 8'h11;
        write_enable = 1;
        @(posedge chip_enable);


        @(negedge chip_enable);
        data_in = 8'hEE;
        @(posedge chip_enable);


        #(2);
        write_enable = 0;
        @(posedge chip_enable);

        #(2);
        #1;

        check_outputs(8'hEE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Address Independence (Write Addr 1 & 2, Read Addr 1)", test_num);
        reset_dut();


        @(negedge chip_enable);
        addr = 3'b001;
        data_in = 8'hBB;
        write_enable = 1;
        @(posedge chip_enable);


        @(negedge chip_enable);
        addr = 3'b010;
        data_in = 8'hCC;
        @(posedge chip_enable);


        @(negedge chip_enable);
        write_enable = 0;
        addr = 3'b001;
        @(posedge chip_enable);

        #(2);
        #1;

        check_outputs(8'hBB);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %03d: Data Pattern 0xFF", test_num);
        reset_dut();


        @(negedge chip_enable);
        addr = 3'b101;
        data_in = 8'hFF;
        write_enable = 1;
        @(posedge chip_enable);


        #(2);
        write_enable = 0;
        @(posedge chip_enable);

        #(2);
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
        $display("sram_cell Testbench");
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
        $dumpvars(0,addr, chip_enable, data_in, write_enable, data_out);
    end

endmodule
