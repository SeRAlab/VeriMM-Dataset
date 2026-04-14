`timescale 1ns/1ps

module sram_32x32_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] addr;
    reg [3:0] byte_enable;
    reg clk;
    reg [31:0] write_data;
    reg write_enable;
    wire [31:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sram_32x32 dut (
        .addr(addr),
        .byte_enable(byte_enable),
        .clk(clk),
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
            addr = 0;
            byte_enable = 0;
            write_data = 0;
            write_enable = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase001: Full word write and read back");
            reset_dut();


            @(posedge clk);
            addr = 5'h05;
            write_data = 32'hDEADBEEF;
            byte_enable = 4'b1111;
            write_enable = 1'b1;

            @(posedge clk);
            write_enable = 1'b0;


            addr = 5'h05;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase002: Partial write - Byte 0 only");
            reset_dut();


            @(posedge clk);
            addr = 5'h0A;
            write_data = 32'hFFFFFFFF;
            byte_enable = 4'b1111;
            write_enable = 1'b1;

            @(posedge clk);

            addr = 5'h0A;
            write_data = 32'h00000099;
            byte_enable = 4'b0001;
            write_enable = 1'b1;

            @(posedge clk);
            write_enable = 1'b0;
            addr = 5'h0A;

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'hFFFFFF99);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase003: Partial write - Bytes 1 and 3");
            reset_dut();


            @(posedge clk);
            addr = 5'h10;
            write_data = 32'h00000000;
            byte_enable = 4'b1111;
            write_enable = 1'b1;

            @(posedge clk);


            addr = 5'h10;
            write_data = 32'hBB00AA00;
            byte_enable = 4'b1010;
            write_enable = 1'b1;

            @(posedge clk);
            write_enable = 1'b0;
            addr = 5'h10;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hBB00AA00);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase004: Verify write_enable = 0 prevents writing");
            reset_dut();


            @(posedge clk);
            addr = 5'h1F;
            write_data = 32'h12345678;
            byte_enable = 4'b1111;
            write_enable = 1'b1;

            @(posedge clk);

            addr = 5'h1F;
            write_data = 32'h87654321;
            byte_enable = 4'b1111;
            write_enable = 1'b0;

            @(posedge clk);

            addr = 5'h1F;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase005: Boundary address check (0 and 31)");
            reset_dut();


            @(posedge clk);
            addr = 5'h00;
            write_data = 32'hAAAA5555;
            byte_enable = 4'b1111;
            write_enable = 1'b1;


            @(posedge clk);
            addr = 5'h1F;
            write_data = 32'h5555AAAA;
            byte_enable = 4'b1111;
            write_enable = 1'b1;

            @(posedge clk);
            write_enable = 1'b0;


            addr = 5'h1F;
            @(posedge clk);
            #1;

            if (read_data !== 32'h5555AAAA) $display("Subtest Fail: Addr 31");


            addr = 5'h00;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase006: Sequential byte overwrite");
            reset_dut();


            @(posedge clk);
            addr = 5'h07;
            write_data = 32'h00000000;
            byte_enable = 4'b1111;
            write_enable = 1'b1;

            @(posedge clk);
            write_data = 32'h00000011;
            byte_enable = 4'b0001;

            @(posedge clk);
            write_data = 32'h00002200;
            byte_enable = 4'b0010;

            @(posedge clk);
            write_data = 32'h00330000;
            byte_enable = 4'b0100;

            @(posedge clk);
            write_data = 32'h44000000;
            byte_enable = 4'b1000;

            @(posedge clk);
            write_enable = 1'b0;
            addr = 5'h07;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h44332211);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sram_32x32 Testbench");
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
        input [31:0] expected_read_data;
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
        $dumpvars(0,addr, byte_enable, clk, write_data, write_enable, read_data);
    end

endmodule
