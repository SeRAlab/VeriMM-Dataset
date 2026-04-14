`timescale 1ns/1ps

module dram_4bit_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg clk;
    reg read_enable;
    reg [3:0] write_data;
    reg write_enable;
    wire [3:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_4bit dut (
        .addr(addr),
        .clk(clk),
        .read_enable(read_enable),
        .write_data(write_data),
        .write_enable(write_enable),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 2'b0;
            read_enable = 1'b0;
            write_data = 4'b0;
            write_enable = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read at Address 0");
            test_num = test_num + 1;
            reset_dut();


            addr = 2'b00;
            write_data = 4'hA;
            write_enable = 1'b1;
            read_enable = 1'b0;
            @(posedge clk);
            #1;


            write_enable = 1'b0;
            read_enable = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Basic Write and Read at Address 3");
            test_num = test_num + 1;
            reset_dut();


            addr = 2'b11;
            write_data = 4'h5;
            write_enable = 1'b1;
            read_enable = 1'b0;
            @(posedge clk);
            #1;


            write_enable = 1'b0;
            read_enable = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Data persistence across multiple addresses");
            test_num = test_num + 1;
            reset_dut();


            addr = 2'b00; write_data = 4'h1; write_enable = 1; @(posedge clk); #1;

            addr = 2'b01; write_data = 4'h2; write_enable = 1; @(posedge clk); #1;

            addr = 2'b10; write_data = 4'h4; write_enable = 1; @(posedge clk); #1;

            addr = 2'b11; write_data = 4'h8; write_enable = 1; @(posedge clk); #1;


            write_enable = 0;
            addr = 2'b01;
            read_enable = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h2);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Overwriting existing data at Address 2");
            test_num = test_num + 1;
            reset_dut();


            addr = 2'b10;
            write_data = 4'hC;
            write_enable = 1'b1;
            @(posedge clk);
            #1;


            write_data = 4'h3;
            @(posedge clk);
            #1;


            write_enable = 1'b0;
            read_enable = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Refresh Operation (No-Op) and verify data integrity");
            test_num = test_num + 1;
            reset_dut();


            addr = 2'b01;
            write_data = 4'hF;
            write_enable = 1'b1;
            @(posedge clk);
            #1;


            write_enable = 1'b0;
            read_enable = 1'b0;
            @(posedge clk);
            @(posedge clk);
            #1;


            read_enable = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hF);
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
        input [3:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,addr, clk, read_enable, write_data, write_enable, read_data);
    end

endmodule
