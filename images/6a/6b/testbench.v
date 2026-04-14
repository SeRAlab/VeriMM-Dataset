`timescale 1ns/1ps

module RegisterFile_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] read_address;
    reg rst_n;
    reg [1:0] write_address;
    reg [15:0] write_data;
    reg write_enable;
    wire [15:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    RegisterFile dut (
        .clk(clk),
        .read_address(read_address),
        .rst_n(rst_n),
        .write_address(write_address),
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
        rst_n = 0;
        write_enable = 0;
        write_address = 0;
        read_address = 0;
        write_data = 0;
        @(posedge clk);
        #1 rst_n = 1;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Reset Verification...");
        test_num = test_num + 1;
        reset_dut();


        read_address = 2'b00;

        @(posedge clk);
        #1 #1;
 check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Single Register Write and Read...");
        test_num = test_num + 1;
        reset_dut();


        write_enable = 1;
        write_address = 2'b01;
        write_data = 16'hABCD;
        @(posedge clk);


        write_enable = 0;
        read_address = 2'b01;
        @(posedge clk);
        #1 #1;
 check_outputs(16'hABCD);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Write Enable Functionality...");
        test_num = test_num + 1;
        reset_dut();


        write_enable = 0;
        write_address = 2'b10;
        write_data = 16'h5555;
        @(posedge clk);


        read_address = 2'b10;
        @(posedge clk);
        #1 #1;
 check_outputs(16'h0000);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Overwriting a Register...");
        test_num = test_num + 1;
        reset_dut();

        write_enable = 1;
        write_address = 2'b11;
        write_data = 16'h1111;
        @(posedge clk);

        write_data = 16'h2222;
        @(posedge clk);

        write_enable = 0;
        read_address = 2'b11;
        @(posedge clk);
        #1 #1;
 check_outputs(16'h2222);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Multi-register Integrity...");
        test_num = test_num + 1;
        reset_dut();

        write_enable = 1;

        write_address = 2'b00;
        write_data = 16'hAAAA;
        @(posedge clk);


        write_address = 2'b01;
        write_data = 16'hBBBB;
        @(posedge clk);

        write_enable = 0;
        read_address = 2'b00;
        @(posedge clk);
        #1 #1;
 check_outputs(16'hAAAA);
    end
        endtask

    task testcase006;

    begin
        $display("Running testcase006: High Address Boundary Check...");
        test_num = test_num + 1;
        reset_dut();

        write_enable = 1;
        write_address = 2'b11;
        write_data = 16'hFFFF;
        @(posedge clk);

        write_enable = 0;
        read_address = 2'b11;
        @(posedge clk);
        #1 #1;
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
        $display("RegisterFile Testbench");
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
        $dumpvars(0,clk, read_address, rst_n, write_address, write_data, write_enable, read_data);
    end

endmodule
