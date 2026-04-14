`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] address;
    reg [3:0] data_in;
    reg write_enable;
    wire [3:0] data_out;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .address(address),
        .data_in(data_in),
        .write_enable(write_enable),
        .data_out(data_out),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        write_enable = 0;
        forever #5 write_enable = ~write_enable;
    end

        task reset_dut;

    begin
        address = 2'b00;
        data_in = 4'h0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Write/Read Address 0", test_num);
        reset_dut();
        @(negedge write_enable);
        address = 2'b00;
        data_in = 4'hA;
        @(posedge write_enable);
        @(negedge write_enable);
        #1;
        #1;

        check_outputs(4'hA, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Write/Read Address 3", test_num);
        reset_dut();
        @(negedge write_enable);
        address = 2'b11;
        data_in = 4'h5;
        @(posedge write_enable);
        @(negedge write_enable);
        #1;
        #1;

        check_outputs(4'h5, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Overwrite Address 1", test_num);
        reset_dut();

        @(negedge write_enable);
        address = 2'b01; data_in = 4'hF;
        @(posedge write_enable); @(negedge write_enable);

        address = 2'b01; data_in = 4'h2;
        @(posedge write_enable); @(negedge write_enable);
        #1;
        #1;

        check_outputs(4'h2, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Persistence Check", test_num);
        reset_dut();

        @(negedge write_enable);
        address = 2'b00; data_in = 4'h7;
        @(posedge write_enable); @(negedge write_enable);

        address = 2'b10; data_in = 4'hC;
        @(posedge write_enable); @(negedge write_enable);

        address = 2'b00;
        #1;
        #1;

        check_outputs(4'h7, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %03d: Data Stability During Read", test_num);
        reset_dut();

        @(negedge write_enable);
        address = 2'b10; data_in = 4'hB;
        @(posedge write_enable); @(negedge write_enable);

        data_in = 4'h0;
        #1;
        #1;

        check_outputs(4'hB, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dram_cell Testbench");
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
        input expected_valid;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, valid=%b",
                         data_out, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, valid=%b",
                         expected_data_out, expected_valid);
                $display("  Got:      data_out=%h, valid=%b",
                         data_out, valid);
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
        $dumpvars(0,address, data_in, write_enable, data_out, valid);
    end

endmodule
