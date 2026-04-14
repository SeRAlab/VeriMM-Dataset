`timescale 1ns/1ps

module reg_file_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] read_addr;
    reg reset;
    reg [1:0] write_addr;
    reg [15:0] write_data;
    reg write_enable;
    wire [15:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file_16bit dut (
        .clk(clk),
        .read_addr(read_addr),
        .reset(reset),
        .write_addr(write_addr),
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
            @(posedge clk);
            reset = 1;
            write_enable = 0;
            write_addr = 0;
            write_data = 0;
            read_addr = 0;
            @(posedge clk);
            reset = 0;

            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Verification", test_num);
            reset_dut();


            read_addr = 2'b01;
            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic Write/Read (Register 2)", test_num);
            reset_dut();

            @(posedge clk);
            write_enable = 1;
            write_addr = 2'b10;
            write_data = 16'hABCD;

            @(posedge clk);
            write_enable = 0;
            read_addr = 2'b10;

            #1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Enable Check", test_num);
            reset_dut();

            @(posedge clk);
            write_enable = 0;
            write_addr = 2'b01;
            write_data = 16'h5555;

            @(posedge clk);
            read_addr = 2'b01;

            #1;
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiple Writes Verification", test_num);
            reset_dut();

            @(posedge clk);
            write_enable = 1;
            write_addr = 2'b00; write_data = 16'h1111;
            @(posedge clk);
            write_addr = 2'b01; write_data = 16'h2222;
            @(posedge clk);
            write_addr = 2'b10; write_data = 16'h3333;
            @(posedge clk);
            write_addr = 2'b11; write_data = 16'h4444;

            @(posedge clk);
            write_enable = 0;
            read_addr = 2'b11;

            #1;
            #1;

            check_outputs(16'h4444);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overwrite Verification", test_num);
            reset_dut();


            @(posedge clk);
            write_enable = 1;
            write_addr = 2'b00;
            write_data = 16'hAAAA;


            @(posedge clk);
            write_data = 16'hFFFF;

            @(posedge clk);
            write_enable = 0;
            read_addr = 2'b00;

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
        $display("reg_file_16bit Testbench");
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
        input [15:0] expected_read_data;
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
        $dumpvars(0,clk, read_addr, reset, write_addr, write_data, write_enable, read_data);
    end

endmodule
