`timescale 1ns/1ps

module register_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] read_addr_1;
    reg [1:0] read_addr_2;
    reg [1:0] write_addr;
    reg [15:0] write_data;
    reg write_enable;
    wire [15:0] read_data_1;
    wire [15:0] read_data_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_file dut (
        .clk(clk),
        .read_addr_1(read_addr_1),
        .read_addr_2(read_addr_2),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        integer i;
        begin
            test_num = test_num + 1;
            write_enable = 0;
            write_addr = 0;
            write_data = 0;
            read_addr_1 = 0;
            read_addr_2 = 0;
            @(posedge clk);

            for (i = 0; i < 4; i = i + 1) begin
                write_enable = 1;
                write_addr = i;
                write_data = 16'h0000;
                @(posedge clk);
            end
            write_enable = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Running Testcase 001: Write to Reg 0, Read from both ports");


            write_enable = 1;
            write_addr = 2'b00;
            write_data = 16'hAAAA;
            @(posedge clk);
            write_enable = 0;


            read_addr_1 = 2'b00;
            read_addr_2 = 2'b00;

            #5;
            #1;

            check_outputs(16'hAAAA, 16'hAAAA);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Running Testcase 002: Write to Reg 1 and 2, Read simultaneously");


            write_enable = 1;
            write_addr = 2'b01;
            write_data = 16'h1234;
            @(posedge clk);


            write_addr = 2'b10;
            write_data = 16'h5678;
            @(posedge clk);
            write_enable = 0;


            read_addr_1 = 2'b01;
            read_addr_2 = 2'b10;

            #5;
            #1;

            check_outputs(16'h1234, 16'h5678);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Running Testcase 003: Verify Write Enable signal");


            write_enable = 1;
            write_addr = 2'b11;
            write_data = 16'hFFFF;
            @(posedge clk);


            write_enable = 0;
            write_addr = 2'b11;
            write_data = 16'h0000;
            @(posedge clk);


            read_addr_1 = 2'b11;
            read_addr_2 = 2'b00;

            #5;
            #1;

            check_outputs(16'hFFFF, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Running Testcase 004: Overwriting register content");


            write_enable = 1;
            write_addr = 2'b01;
            write_data = 16'hCCCC;
            @(posedge clk);


            write_addr = 2'b01;
            write_data = 16'h3333;
            @(posedge clk);
            write_enable = 0;

            read_addr_1 = 2'b01;
            read_addr_2 = 2'b00;

            #5;
            #1;

            check_outputs(16'h3333, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Running Testcase 005: Write all and verify Reg 3 and Reg 0");

            write_enable = 1;

            write_addr = 2'b00; write_data = 16'h0001; @(posedge clk);

            write_addr = 2'b01; write_data = 16'h0002; @(posedge clk);

            write_addr = 2'b10; write_data = 16'h0004; @(posedge clk);

            write_addr = 2'b11; write_data = 16'h0008; @(posedge clk);
            write_enable = 0;

            read_addr_1 = 2'b11;
            read_addr_2 = 2'b00;

            #5;
            #1;

            check_outputs(16'h0008, 16'h0001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_file Testbench");
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
        input [15:0] expected_read_data_1;
        input [15:0] expected_read_data_2;
        begin
            if (expected_read_data_1 === (expected_read_data_1 ^ read_data_1 ^ expected_read_data_1) &&
                expected_read_data_2 === (expected_read_data_2 ^ read_data_2 ^ expected_read_data_2)) begin
                $display("PASS");
                $display("  Outputs: read_data_1=%h, read_data_2=%h",
                         read_data_1, read_data_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data_1=%h, read_data_2=%h",
                         expected_read_data_1, expected_read_data_2);
                $display("  Got:      read_data_1=%h, read_data_2=%h",
                         read_data_1, read_data_2);
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
        $dumpvars(0,clk, read_addr_1, read_addr_2, write_addr, write_data, write_enable, read_data_1, read_data_2);
    end

endmodule
