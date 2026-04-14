`timescale 1ns/1ps

module reg_file_16x8_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] read_addr;
    reg rst_n;
    reg we;
    reg [2:0] write_addr;
    reg [15:0] write_data;
    wire [15:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file_16x8 dut (
        .clk(clk),
        .read_addr(read_addr),
        .rst_n(rst_n),
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
            rst_n = 0;
            we = 0;
            write_addr = 0;
            write_data = 0;
            read_addr = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Checking reset state of Register 0...", test_num);
            reset_dut();


            read_addr = 3'd0;


            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Writing 0xABCD to Register 3 and reading back...", test_num);
            reset_dut();


            @(negedge clk);
            we = 1;
            write_addr = 3'd3;
            write_data = 16'hABCD;

            @(posedge clk);
            #1 we = 0;


            read_addr = 3'd3;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Attempting write when WE is low...", test_num);
            reset_dut();


            @(negedge clk);
            we = 0;
            write_addr = 3'd5;
            write_data = 16'h5555;

            @(posedge clk);
            #1;


            read_addr = 3'd5;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("\nTestcase %0d: Writing unique values to all 8 registers...", test_num);
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                @(negedge clk);
                we = 1;
                write_addr = i;
                write_data = 16'h1000 + i;
            end

            @(negedge clk);
            we = 0;


            read_addr = 3'd7;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'h1007);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Overwriting Register 2...", test_num);
            reset_dut();


            @(negedge clk);
            we = 1;
            write_addr = 3'd2;
            write_data = 16'hAAAA;
            @(posedge clk);


            @(negedge clk);
            write_data = 16'hBBBB;
            @(posedge clk);
            #1 we = 0;


            read_addr = 3'd2;
            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hBBBB);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTestcase %0d: Simultaneous Write to Reg 1 and Read from Reg 0...", test_num);
            reset_dut();


            @(negedge clk);
            we = 1;
            write_addr = 3'd0;
            write_data = 16'hCAFE;
            @(posedge clk);


            @(negedge clk);
            we = 1;
            write_addr = 3'd1;
            write_data = 16'hBABE;
            read_addr = 3'd0;

            @(posedge clk);
            #2;

            #1;


            check_outputs(16'hCAFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file_16x8 Testbench");
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
        $dumpvars(0,clk, read_addr, rst_n, we, write_addr, write_data, read_data);
    end

endmodule
