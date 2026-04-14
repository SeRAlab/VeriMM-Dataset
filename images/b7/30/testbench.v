`timescale 1ns/1ps

module reg_file_8bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] read_addr;
    reg rst;
    reg we;
    reg [2:0] write_addr;
    reg [7:0] write_data;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file_8bit dut (
        .clk(clk),
        .read_addr(read_addr),
        .rst(rst),
        .we(we),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        we = 0;
        write_addr = 0;
        write_data = 0;
        read_addr = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Reset State Check", test_num);
        reset_dut();

        read_addr = 3'd0;
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Simple Write and Read (Addr 1)", test_num);
        reset_dut();


        we = 1;
        write_addr = 3'd1;
        write_data = 8'hAA;
        @(posedge clk);
        #1 we = 0;


        read_addr = 3'd1;
        #1;
        #1;

        check_outputs(8'hAA);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Write Enable De-asserted Check", test_num);
        reset_dut();


        we = 0;
        write_addr = 3'd2;
        write_data = 8'hFF;
        @(posedge clk);
        #1;


        read_addr = 3'd2;
        #1;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Overwrite Register Check", test_num);
        reset_dut();


        we = 1;
        write_addr = 3'd5;
        write_data = 8'h11;
        @(posedge clk);
        #1;


        write_data = 8'h22;
        @(posedge clk);
        #1 we = 0;

        read_addr = 3'd5;
        #1;
        #1;

        check_outputs(8'h22);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Multiple Registers and Persistence Check", test_num);
        reset_dut();

        we = 1;

        write_addr = 3'd0; write_data = 8'h0A; @(posedge clk); #1;

        write_addr = 3'd7; write_data = 8'h7E; @(posedge clk); #1;

        write_addr = 3'd3; write_data = 8'h3C; @(posedge clk); #1;

        we = 0;

        read_addr = 3'd7;
        #1;
        #1;

        check_outputs(8'h7E);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Simultaneous Read and Write Check", test_num);
        reset_dut();


        we = 1;
        write_addr = 3'd1;
        write_data = 8'hB1;
        @(posedge clk); #1;


        write_addr = 3'd2;
        write_data = 8'hB2;
        read_addr = 3'd1;
        @(posedge clk); #1;


        #1;



        check_outputs(8'hB1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: All Bits High Check", test_num);
        reset_dut();

        we = 1;
        write_addr = 3'd4;
        write_data = 8'hFF;
        @(posedge clk); #1;

        we = 0;
        read_addr = 3'd4;
        #1;
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
        $display("reg_file_8bit Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_read_data;
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
        $dumpvars(0,clk, read_addr, rst, we, write_addr, write_data, read_data);
    end

endmodule
